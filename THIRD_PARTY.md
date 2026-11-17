# Сторонние материалы

Копии скиллов в репозитории не хранятся. Здесь описаны их источники; машиночитаемый список находится в `skills.json`. Установка и обновление выполняются через `scripts/Install-Skills.ps1`.

| Что | Источник | Версия | Лицензия |
|---|---|---|---|
| Скиллы 1С: `cf-*`, `cfe-*`, `db-*`, `epf-*`, `erf-*`, `form-*`, `help-add`, `img-grid`, `interface-*`, `meta-*`, `mxl-*`, `role-*`, `skd-*`, `subsystem-*`, `support-edit`, `template-*`, `v8-xsd-fetch`, `xdto-*`; `web-*` не ставятся (`exclude` в `skills.json`) | [Nikolay-Shirokov/cc-1c-skills](https://github.com/Nikolay-Shirokov/cc-1c-skills), каталог `.agents/skills/`, ветка `port-agents` | актуальное состояние ветки при запуске; установщик выводит коммит | MIT |
| `mermaid-diagrams` | [ccheney/robust-skills](https://github.com/ccheney/robust-skills), каталог `skills/mermaid-diagrams/`, ветка `main` | актуальное состояние ветки при запуске; установщик выводит коммит | MIT, Copyright (c) 2026 robust-skills contributors |
| `powershell-safe-invocation` | [Misaka-Mikoto-Tech/agent-skills](https://github.com/Misaka-Mikoto-Tech/agent-skills), каталог `skills/powershell-safe-invocation/`, ветка `main` | актуальное состояние ветки при запуске; установщик выводит коммит | MIT, Copyright (c) 2026 Misaka Mikoto |
| `grillme` | Локальная установка `~/.agents/skills/grillme` | состояние локального источника при запуске | не указана в локальном источнике |

Скиллы 1С взяты из ветки `port-agents` — это сборка автора с PowerShell-скриптами под общую папку `.agents/skills/` стандарта Agent Skills. Ветка пересобирается автоматически из `main` при каждом изменении скиллов.

Установленные файлы обновляются целиком из источников. `grillme` не имеет указанного внешнего адреса: на другом компьютере требуется локальный источник либо замена ссылки в списке источников.

## Лицензия cc-1c-skills

```
MIT License

Copyright (c) 2025-2026 Nick Shirokov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
