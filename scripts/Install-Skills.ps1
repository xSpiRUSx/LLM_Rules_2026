#Requires -Version 7.0
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $Destination,
    [string] $Manifest = (Join-Path $PSScriptRoot '../skills.json')
)

$ErrorActionPreference = 'Stop'
$config = Get-Content -LiteralPath $Manifest -Raw | ConvertFrom-Json
if ($config.schemaVersion -ne 1) { throw 'Unsupported skills manifest version.' }
$target = [IO.Path]::GetFullPath($Destination)
$work = Join-Path ([IO.Path]::GetTempPath()) ('llm-skills-' + [guid]::NewGuid())
$stage = Join-Path $work 'stage'
$resolvedSources = @()
$names = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
$cleanup = $true

try {
    New-Item -ItemType Directory -Path $stage -Force | Out-Null
    foreach ($source in $config.sources) {
        $revision = $null
        switch ($source.type) {
            'git' {
                $checkout = Join-Path $work ([guid]::NewGuid().ToString())
                & git clone --quiet --depth 1 --branch $source.ref -- $source.url $checkout
                if ($LASTEXITCODE -ne 0) { throw "Cannot download $($source.name)." }
                $revision = (& git -C $checkout rev-parse HEAD)
                if ($LASTEXITCODE -ne 0) { throw "Cannot resolve $($source.name)." }
                $root = Join-Path $checkout $source.path
            }
            'home' { $root = Join-Path ([Environment]::GetFolderPath('UserProfile')) $source.path }
            default { throw "Unknown source type: $($source.type)" }
        }
        if (-not (Test-Path -LiteralPath $root -PathType Container)) {
            throw "Skill source is missing: $root"
        }
        $skills = if ($source.skill) { @(Get-Item -LiteralPath $root) }
                  else { @(Get-ChildItem -LiteralPath $root -Directory | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') }) }
        if ($skills.Count -eq 0) { throw "No skills found in $($source.name)." }
        foreach ($skill in $skills) {
            $name = if ($source.skill) { [string]$source.skill } else { $skill.Name }
            if ($name -notmatch '^[a-zA-Z0-9][a-zA-Z0-9_-]*$') { throw "Invalid skill name: $name" }
            if (-not $names.Add($name)) { throw "Duplicate skill: $name" }
            if (-not (Test-Path -LiteralPath (Join-Path $skill.FullName 'SKILL.md') -PathType Leaf)) {
                throw "SKILL.md is missing: $($skill.FullName)"
            }
            $existing = Join-Path $target $name
            if (Test-Path -LiteralPath $existing) {
                $item = Get-Item -LiteralPath $existing -Force
                if (-not $item.PSIsContainer -or $item.LinkType -or
                    -not (Test-Path -LiteralPath (Join-Path $existing 'SKILL.md') -PathType Leaf)) {
                    throw "Destination is not a regular skill directory: $existing"
                }
            }
            # Copy all support files along with SKILL.md before touching installed skills.
            Copy-Item -LiteralPath $skill.FullName -Destination (Join-Path $stage $name) -Recurse
            if ($source.type -eq 'git' -and (Test-Path -LiteralPath (Join-Path $checkout 'LICENSE') -PathType Leaf)) {
                Copy-Item -LiteralPath (Join-Path $checkout 'LICENSE') -Destination (Join-Path $stage "$name/LICENSE.upstream")
            }
        }
        $resolvedSources += [pscustomobject]@{ name = $source.name; revision = $revision; count = $skills.Count }
    }

    New-Item -ItemType Directory -Path $target -Force | Out-Null
    $backup = Join-Path $work 'backup'
    New-Item -ItemType Directory -Path $backup | Out-Null
    $installed = @()
    $saved = @()
    try {
        foreach ($name in $names) {
            $existing = Join-Path $target $name
            if (Test-Path -LiteralPath $existing) {
                Move-Item -LiteralPath $existing -Destination (Join-Path $backup $name)
                $saved += $name
            }
            Move-Item -LiteralPath (Join-Path $stage $name) -Destination $existing
            $installed += $name
        }
    }
    catch {
        $installError = $_
        try {
            foreach ($name in $installed) { Remove-Item -LiteralPath (Join-Path $target $name) -Recurse -Force }
            foreach ($name in $saved) { Move-Item -LiteralPath (Join-Path $backup $name) -Destination (Join-Path $target $name) }
        }
        catch {
            $cleanup = $false
            throw "Update and rollback failed. Backups retained in ${backup}. $installError $_"
        }
        throw $installError
    }
    Write-Output "Installed/updated $($names.Count) skills in $target"
    $resolvedSources | Format-Table -AutoSize
}
finally {
    # Only delete the unique temporary directory created by this invocation.
    if ($cleanup -and (Split-Path $work -Parent) -eq [IO.Path]::GetTempPath().TrimEnd('\', '/') -and
        (Split-Path $work -Leaf) -match '^llm-skills-[0-9a-f-]+$' -and
        (Test-Path -LiteralPath $work)) {
        Remove-Item -LiteralPath $work -Recurse -Force
    }
}
