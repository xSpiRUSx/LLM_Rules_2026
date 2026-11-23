# Changelog

Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.1.0/), версии — по [SemVer](https://semver.org/lang/ru/).

## [Unreleased]

### Changed

- `rules/AGENTS.md`: раздел «Характер» — позиция агента (честность, скепсис, споры с плохими запросами, исследование, юмор) собрана из «Коммуникации» и «Автономности»; добавлено «не знаешь — скажи, не выдумывай».
- `rules/AGENTS.md`: контракт активной роли может разрешать делегирование в своих границах; прямой запрет пользователя имеет приоритет.
- `rules/instructions/github.md`: для мелких и технических правок PR без issue, ветка `chore/<кратко>` или `fix/<кратко>`; несколько технических правок можно собрать в один PR отдельными коммитами, не смешивая с доработками.
- `rules/github/pull_request_template.md`: строка `Closes #` удаляется, если PR не закрывает issue.
- `rules/AGENTS.md`, `rules/instructions/github.md`: работа только в основном каталоге проекта — запрещены worktree, клоны и копии проекта (в том числе для субагентов и новых сессий), кроме как по прямой просьбе пользователя; ветки переключаются на месте.

## [0.4.0] - 2026-11-17

### Changed

- `scripts/Install-Skills.ps1`: поле `exclude` в `skills.json` — маски скиллов источника, которые не ставятся.
- `skills.json`: скиллы `web-*` из cc-1c-skills не ставятся.
- `scripts/Install-Rules.ps1`: в `.gitignore` проекта добавляется `/.agents/skills/` — скиллы не коммитятся, их ставит установщик на каждом компьютере.

## [0.3.0] - 2026-11-17

### Added

- `rules/AGENTS.md`: анализ кода конфигурации обязательно через MCP-сервер `rlm-tools-bsl`; если сервер не подключён — вопрос пользователю; по окончании анализа сессия закрывается через `rlm_end`.
- `rules/AGENTS.md`: проверка изменённых BSL-модулей через BSL Language Server; если анализатора нет — вопрос пользователю.
- `README.md`: установка BSL Language Server при подготовке компьютера.
- `rules/instructions/github.md` — порядок работы с issue, ветками, коммитами и PR.
- `rules/github/` — шаблоны issue (`feature`, `bug`, `epic`) и PR; установщик добавляет в `.github/` проекта недостающие файлы, существующие не трогает.
- `rules/AGENTS.md`: субагенты запускаются только по прямой просьбе пользователя или по инструкции навыка.
- Скиллы `mermaid-diagrams` из [robust-skills](https://github.com/ccheney/robust-skills) и `powershell-safe-invocation` из [agent-skills](https://github.com/Misaka-Mikoto-Tech/agent-skills) в `skills.json`.
- `README.md`: подготовка компьютера — установка `rlm-tools-bsl` и регистрация сервера в агенте.

## [0.2.0] - 2026-11-17

### Added

- `rules/AGENTS.md` — заготовка правил, распространяемых в проекты.
- Папки `rules/instructions/`, `rules/docs/` под общие инструкции и справку.
- Инструкции `rules/instructions/`: `1c-style.md`, `architecture.md`, `extensions.md`, `form-ui.md`, `queries-performance.md`.
- `rules/project-context.md` — шаблон контекста проекта, который агент заполняет при первой работе в проекте.
- `skills.json` — ссылки на источники скиллов 1С из [cc-1c-skills](https://github.com/Nikolay-Shirokov/cc-1c-skills) (ветка `port-agents`, папка `.agents/skills/`) и локальный источник `grillme`; копии скиллов не хранятся в репозитории.
- `scripts/Install-Rules.ps1` — установка и обновление правил в проекте из выбранного тега: `AGENTS.md`, `.agents/instructions/`, `.agents/docs/`, шаблон `.agents/project-context.md`, `CLAUDE.md`, строки `.gitignore`, скиллы в `.agents/skills/` и ссылка `.claude/skills` для Claude Code.
- `scripts/Install-Skills.ps1` — установка и обновление скиллов вместе со вспомогательными файлами в указанную папку; загрузка всех источников до замены установленных скиллов.
- `THIRD_PARTY.md` — происхождение скиллов и сведения об их лицензиях.
- `rules/instructions/build-deploy.md` — сборка, загрузка и обновление базы через навыки `epf-*`, `erf-*`, `db-*`; настройки проекта в `.v8-project.json`.
- Корневые `AGENTS.md` и `CLAUDE.md` — правила работы агента в самом репозитории.

### Changed

- Ссылки на инструкции в `rules/AGENTS.md` ведут в `.agents/instructions/` — туда их кладёт установщик.

### Removed

- Папка `rules/skills/`: копии скиллов не хранятся в репозитории, источники перечислены в `skills.json`.

## [0.1.0] - 2026-11-16

### Added

- Каркас репозитория: `rules/`, `VERSION`, `CHANGELOG.md`.
- Правила версионирования и порядок выпуска обновлений в `README.md`.
