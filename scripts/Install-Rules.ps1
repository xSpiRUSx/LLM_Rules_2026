#Requires -Version 7.0
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $Project,
    # Тег или другая ссылка git. По умолчанию — последний тег vX.Y.Z.
    [string] $Version
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$project = [IO.Path]::GetFullPath($Project)
if (-not (Test-Path -LiteralPath $project -PathType Container)) { throw "Project folder not found: $project" }

if (-not $Version) {
    $Version = git -C $repo tag --list 'v*' --sort=-v:refname | Select-Object -First 1
    if (-not $Version) { throw 'No version tags found.' }
}

$work = Join-Path ([IO.Path]::GetTempPath()) ('llm-rules-' + [guid]::NewGuid())
try {
    # Снимок выбранной версии: правила, список навыков и установщик навыков берутся из неё же.
    New-Item -ItemType Directory -Path $work | Out-Null
    $zip = Join-Path $work 'rules.zip'
    git -C $repo archive --format=zip -o $zip $Version
    if ($LASTEXITCODE -ne 0) { throw "Unknown version: $Version" }
    $src = Join-Path $work 'src'
    Expand-Archive -LiteralPath $zip -DestinationPath $src
    $rules = Join-Path $src 'rules'
    if (-not (Test-Path -LiteralPath (Join-Path $src 'skills.json'))) { throw "Version $Version has no skills.json and cannot be installed." }

    $agents = Join-Path $project '.agents'
    $agentsMd = Join-Path $project 'AGENTS.md'
    $versionFile = Join-Path $agents 'VERSION'

    # AGENTS.md принадлежит установщику. Чужой файл при первой установке не перезаписываем.
    if ((Test-Path -LiteralPath $agentsMd) -and -not (Test-Path -LiteralPath $versionFile)) {
        throw "AGENTS.md already exists in $project. Move project-specific rules to .agents/project-context.md and delete AGENTS.md."
    }

    New-Item -ItemType Directory -Path $agents -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $rules 'AGENTS.md') -Destination $agentsMd -Force
    foreach ($dir in 'instructions', 'docs') {
        $dst = Join-Path $agents $dir
        if (Test-Path -LiteralPath $dst) { Remove-Item -LiteralPath $dst -Recurse -Force }
        New-Item -ItemType Directory -Path $dst | Out-Null
        Get-ChildItem -LiteralPath (Join-Path $rules $dir) -Exclude '.gitkeep' | Copy-Item -Destination $dst -Recurse
    }
    $context = Join-Path $agents 'project-context.md'
    if (-not (Test-Path -LiteralPath $context)) { Copy-Item -LiteralPath (Join-Path $rules 'project-context.md') -Destination $context }

    $claudeMd = Join-Path $project 'CLAUDE.md'
    if (-not (Test-Path -LiteralPath $claudeMd)) { Set-Content -LiteralPath $claudeMd -Value '@AGENTS.md' }
    elseif (-not (Select-String -LiteralPath $claudeMd -Pattern '^@AGENTS\.md' -Quiet)) {
        Write-Warning 'CLAUDE.md does not import AGENTS.md. Add the line @AGENTS.md.'
    }

    $gitignore = Join-Path $project '.gitignore'
    $text = if (Test-Path -LiteralPath $gitignore) { Get-Content -LiteralPath $gitignore -Raw } else { '' }
    $missing = @('.v8-project.json', '/.claude/skills') | Where-Object { $_ -notin ($text -split '\r?\n') }
    if ($missing) {
        $prefix = if ($text -and -not $text.EndsWith("`n")) { "`n" } else { '' }
        [IO.File]::AppendAllText($gitignore, $prefix + ($missing -join "`n") + "`n")
    }

    $skills = Join-Path $agents 'skills'
    & (Join-Path $src 'scripts/Install-Skills.ps1') -Destination $skills -Manifest (Join-Path $src 'skills.json')

    # Claude Code читает навыки только из .claude/skills — направляем его в .agents/skills.
    $link = Join-Path $project '.claude/skills'
    if (Test-Path -LiteralPath $link) {
        if (-not (Get-Item -LiteralPath $link -Force).LinkType) {
            throw "$link is a regular folder. Move its skills to .agents/skills and delete it."
        }
        Remove-Item -LiteralPath $link -Force
    }
    New-Item -ItemType Directory -Path (Split-Path $link -Parent) -Force | Out-Null
    New-Item -ItemType Junction -Path $link -Target $skills | Out-Null

    Set-Content -LiteralPath $versionFile -Value $Version
    Write-Output "Rules $Version installed in $project"
}
finally {
    if ((Split-Path $work -Leaf) -match '^llm-rules-[0-9a-f-]+$' -and (Test-Path -LiteralPath $work)) {
        Remove-Item -LiteralPath $work -Recurse -Force
    }
}
