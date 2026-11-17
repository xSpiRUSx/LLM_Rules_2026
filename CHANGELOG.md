# Changelog

Формат основан на [Keep a Changelog](https://keepachangelog.com/ru/1.1.0/), версии — по [SemVer](https://semver.org/lang/ru/).

## [Unreleased]

### Added

- `rules/AGENTS.md`: анализ кода конфигурации обязательно через MCP-сервер `rlm-tools-bsl`; если сервер не подключён — вопрос пользователю; по окончании анализа сессия закрывается через `rlm_end`.
- `rules/AGENTS.md`: субагенты запускаются только по прямой просьбе пользователя или по инструкции навыка.
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
