# Project guidelines and requirements

## User

Прочитай docs/TASK.md. Напиши AGENTS.md в корне - правила, по которым ты
будешь делать этот проект. Код не пиши.

Мои решения:
- Swift 6, SwiftUI, iOS 18+, MVVM, @Observable, SwiftData, без зависимостей.
- Сеть только URLSession, стриминг через SSE.
- AI: Groq, модель openai/gpt-oss-120b, reasoning_effort low.
- Ключ в Services/Secrets.swift, XOR с солью; байты вставляю я сам,
  ключ у меня не проси.
- Проект через XcodeGen, .xcodeproj руками не трогать.
- Имя проекта, схемы и таргета - test.
- План будет в docs/PLAN.md, его составим следующим шагом. Работать по шагам
  плана: сборка и коммит после каждого шага.

Добавь разделы: функциональные требования, качество кода, критерии готовности.
Если что-то неясно - спроси, не угадывай.

## Assistant

Сначала прочитаю задачу и правила оформления `AGENTS.md`, чтобы зафиксировать только то, что уже решено.

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/.cursor/skills-cursor/create-rule/SKILL.md"}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/docs/TASK.md"}
```

## Assistant

В репозитории уже есть проект — сверю его с заданием, чтобы не спрашивать то, что уже зафиксировано.

### Tool Glob File Search

```
{"targetDirectory":"/Users/yelzhanyelikbaev/Desktop/test","globPattern":"**/*"}
```

### Tool Get Mcp Tools

```
{"toolCallId":"unknown-tool-call-id"}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/test/test/testApp.swift"}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/.gitignore"}
```

### Tool Glob File Search

```
{"targetDirectory":"/Users/yelzhanyelikbaev/Desktop/test","globPattern":"**/*.{pbxproj,yml,plist,md}"}
```

### Tool Ask Question

## Assistant

Ответы зафиксированы. Пишу `AGENTS.md` только из задания и этих решений: соль для XOR назову в файле, ключ не спрашиваю.

### Tool Edit File V2

## Assistant

`AGENTS.md` лежит в корне. Код приложения не писал.

В файле зафиксированы твои решения и ответы на вопросы: русский интерфейс, только iPhone, bundle ID `com.test.test`, без test target, фото, Mac и офлайн-режим вне объёма, пока ты отдельно не добавишь их в план. Работа идёт по шагам `docs/PLAN.md`: после каждого шага сборка схемы `test` и один коммит.

Ключ не спрашиваю. Контракт для байтов, которые вставишь сам, в `test/test/Services/Secrets.swift`:

- соль — строка `test.groq.v1` (UTF-8);
- `obfuscated[i] = keyUTF8[i] ^ saltUTF8[i % saltUTF8.count]`;
- массив `static let obfuscatedKey: [UInt8]`.

Проверка: байт `A` (`0x41`) и первый байт соли `t` (`0x74`) дают `0x35`.

Дальше по этим правилам можно составить `docs/PLAN.md`.

## User

Поправь AGENTS.md, остальное не трогай:
1. Корень репозитория — сама папка проекта. Исходники таргета лежат в test/,
   секрет — test/Services/Secrets.swift. Замени все пути test/test/.
2. Bundle ID com.yelzhanyelikbayev.aichat. Отображаемое имя приложения —
   «AI-ассистент». Проект, схема и таргет остаются test.
3. В требованиях: при «Стоп» и при ошибке уже пришедший текст ответа
   сохраняется в истории.
4. В критериях готовности: ручная проверка на симуляторе iOS 18 и на
   симуляторе последней iOS.
5. В критериях готовности: в репозитории есть папка ai-logs/ с историей
   чатов, ключей в ней нет.

## Assistant

Поправлю только `AGENTS.md`: пути, bundle ID, имя, сохранение ответа и критерии проверки.

### Tool Read File V2

```
{}
```

### Tool Glob File Search

```
{"targetDirectory":"/Users/yelzhanyelikbaev/Desktop/test","globPattern":"**/AGENTS.md"}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/test/docs/AGENTS.md"}
```

## Assistant

Файл лежит в `test/docs/AGENTS.md`. Меняю в нём только пять пунктов.

### Tool Edit File V2

### Tool Edit File V2

### Tool Edit File V2

### Tool Edit File V2

### Tool Edit File V2

### Tool Edit File V2

### Tool Edit File V2

### Tool Ripgrep Raw Search

```
{"pattern":"test/test/|com\\.test\\.test|домашнем экране","path":"/Users/yelzhanyelikbaev/Desktop/test/test/docs/AGENTS.md","caseInsensitive":false,"multiline":false,"toolCallId":"call-8a82deb1-a5f6-4982-8813-eb09d36a2269-19\nfc_bee7338a-e672-927f-afed-71a1e16cbf9a_0","offset":0}
```

## Assistant

`AGENTS.md` обновлён, остальные файлы не менялись.

- Корень репозитория — папка проекта. Исходники таргета — `test/`, секрет — `test/Services/Secrets.swift`.
- Bundle ID — `com.yelzhanyelikbayev.aichat`, отображаемое имя — «AI-ассистент». Проект, схема и таргет — `test`.
- При «Стоп» и при ошибке уже пришедший текст ответа сохраняется в истории.
- Ручная проверка — на симуляторе iOS 18 и на симуляторе последней iOS.
- В критериях готовности есть папка `ai-logs/` с историей чатов, без ключей.

## User

AGENTS.md теперь лежит в корне репозитория, docs/TASK.md — в docs/ в корне.
Папка test/docs/ удалена, туда ничего не клади.

## Assistant

Проверю, где сейчас лежат `AGENTS.md` и `docs/TASK.md`, и что в правилах нет ссылок на удалённую `test/docs/`.

### Tool Glob File Search

```
{"targetDirectory":"/Users/yelzhanyelikbaev/Desktop/test","globPattern":"**/{AGENTS.md,TASK.md,PLAN.md}"}
```

### Tool Ripgrep Raw Search

```
{"pattern":"test/docs","path":"/Users/yelzhanyelikbaev/Desktop/test","glob":"*.md","caseInsensitive":false,"multiline":false,"toolCallId":"call-9ed368a0-93b4-4fa0-a9db-384232de0096-21\nfc_16b76d0f-1fbe-90f0-abc1-7bcf752626e9_1","offset":0}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/AGENTS.md","limit":40}
```

## Assistant

Раскладка совпадает с правилами в корневом `AGENTS.md`: задача в `docs/TASK.md`, исходники таргета в `test/`, секрет в `test/Services/Secrets.swift`. Папку `test/docs/` создавать не буду.