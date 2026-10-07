# README update and verification

## User

Выполни шаг 9 из docs/PLAN.md. Черновик README  ниже, доделай и сохрани его как
README.md в корне. Сверь разделы «Сделано» и «Как проверяли» с кодом и
сообщи, если что-то не совпадает. Время 4 часа 4 минуты Сделай коммит.

# AI-ассистент

## Время
3 ч 45 мин.

## Инструменты
Cursor, модель Grok 4.7 (high, fast) — правила для агента, план и весь код
по шагам из docs/PLAN.md.

## AI в приложении
Groq, модель openai/gpt-oss-120b. Бесплатный тариф: 8 тыс. токенов в минуту
и 200 тыс. в день, поэтому при нескольких длинных ответах подряд возможна
ошибка «Кончился лимит API» — через минуту «Повторить» срабатывает.

## Сделано
- Несколько чатов: создание, удаление свайпом, история после перезапуска.
  Пустой чат без сообщений не сохраняется.
- Потоковый ответ: текст появляется по мере генерации, до первого фрагмента —
  анимированный индикатор из трёх точек.
- Кнопка «Стоп»: обрывает запрос, уже пришедший текст сохраняется.
- Ошибки «Нет сети», «Кончился лимит API» и общая, у каждой «Повторить».
  Вопрос, оставшийся без ответа, можно повторить и после перезапуска.
- Умная прокрутка: лента следует за ответом, пока пользователь у нижнего
  края, и не тянет вниз, если он прокрутил вверх.
- Встроенная разметка в ответах: жирный, курсив, код.
- Светлая и тёмная тема, системные компоненты и цвета, интерфейс на русском.

## Не сделано и известные баги
- Опциональные пункты не делались: фото во вложении, версия для Mac,
  офлайн-режим.
- Автотестов нет, проверка ручная и через превью.
- Повтор после частично полученного ответа добавляет новый ответ отдельным
  сообщением, обрывок остаётся в истории.

## Как проверяли
Вручную на симуляторах iPhone XR (iOS 18.3.1) и iPhone 17 Pro (iOS 26.4.1),
в светлой и тёмной теме.
- Список чатов: создание, удаление, пустой экран, сохранение после
  перезапуска.
- Генерация: ответ приходит по частям; «Стоп» обрывает вывод, текст
  остаётся в истории и после перезапуска.
- Без сети: «Нет сети» и «Повторить»; после включения сети повтор уходит
  без перезапуска приложения и без второй копии сообщения.
- Обрыв соединения посреди ответа: пришедший текст сохраняется, появляется
  ошибка. Таймаут ожидания данных — 15 с.
- Лимит API: в превью с подставным сервисом и вживую — исчерпал минутный
  лимит токенов, получил ту же ошибку, через минуту повтор сработал.
- Умная прокрутка: прокрутка вверх во время ответа, возврат вниз, новое
  сообщение, открытие чата в конце переписки.
- Свежий клон репозитория собирается двойным кликом по Build.command.
- Поиск gsk_ по проекту, логам и истории git открытого ключа не находит.
- При проверке найдены и исправлены: зависание при обрыве сети, поломка
  чата при выходе во время генерации, пустой экран при открытии чата,
  сохранение пустых чатов, потеря сети до перезапуска приложения.

## Assistant

Сначала сверю шаг 9 в плане и черновик README с кодом, потом сохраню файл и закоммичу.

### Tool Glob File Search

```
{"globPattern":"docs/**/*"}
```

### Tool Glob File Search

```
{"globPattern":"README*"}
```

### Tool Glob File Search

```
{"globPattern":"**/*.{swift,yml,md}"}
```

### Tool Ripgrep Raw Search

```
{"pattern":"^## |^### |Шаг 9|шаг 9","path":"/Users/yelzhanyelikbaev/Desktop/test/docs/PLAN.md","caseInsensitive":false,"multiline":false,"toolCallId":"call-41fd4e09-8ae7-4d3a-beb6-9e9674f342a4-3\nfc_a523e804-6ff7-96eb-b027-4fde449809ca_0","offset":0}
```

### Tool Ripgrep Raw Search

```
{"pattern":"README|Время|Инструменты|Сделано|Как проверяли","path":"/Users/yelzhanyelikbaev/Desktop/test/docs/TASK.md","caseInsensitive":false,"multiline":false,"toolCallId":"call-41fd4e09-8ae7-4d3a-beb6-9e9674f342a4-4\nfc_a523e804-6ff7-96eb-b027-4fde449809ca_1","offset":0}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/docs/PLAN.md","offset":148,"limit":50}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/docs/TASK.md"}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/docs/PLAN.md","offset":1,"limit":170}
```

## Assistant

Шаг 9 — README и сверка с кодом, без новых фич. Смотрю реализацию заявлений из черновика.

### Tool Ripgrep Raw Search

```
{"pattern":"timeout|15|Нет сети|Кончился лимит|Не удалось получить ответ|Ответ не получен|reduceMotion|three|dots|Markdown|AttributedString|obfuscatedKey|networkConnectionLost|retry|isFollowing|defaultScrollAnchor","path":"/Users/yelzhanyelikbaev/Desktop/test/test","glob":"*.swift","caseInsensitive":false,"multiline":false,"toolCallId":"call-0685f23e-8687-4950-a159-378ba4872678-8\nfc_57945141-b966-9c99-b2ec-4ec3c4285feb_0","offset":0}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/test/Services/GroqChatService.swift","limit":200}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/project.yml"}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/test/ChatScreenModel.swift"}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/test/ChatView.swift"}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/test/ChatListModel.swift"}
```

### Tool Read File V2

```
{}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/test/ChatListView.swift"}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/test/testApp.swift"}
```

### Tool Ripgrep Raw Search

```
{"pattern":"gsk_","path":"/Users/yelzhanyelikbaev/Desktop/test","glob":"*.{swift,md,yml,command,plist,json,txt}","caseInsensitive":false,"multiline":false,"toolCallId":"call-0d696668-7cf7-4f21-a2e3-a4a2130f5e50-17\nfc_16049764-26f0-98bd-bea6-b42a25847161_2","offset":0}
```

### Tool Glob File Search

```
{"globPattern":"**/*Test*"}
```

### Tool Read File V2

```
{}
```

### Tool Ripgrep Raw Search

```
{"pattern":"gsk_","path":"/Users/yelzhanyelikbaev/Desktop/test","glob":"*.swift","caseInsensitive":false,"multiline":false,"toolCallId":"call-d1ea8500-c915-47fa-b24f-2f45689949f6-20\nfc_918dde4a-d554-9a07-8915-3cd61ca45d02_1","offset":0}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/test/Services/ChatService.swift"}
```

### Tool Read File V2

```
{"path":"/Users/yelzhanyelikbaev/Desktop/test/Build.command"}
```

### Tool Run Terminal Command V2

### Tool Run Terminal Command V2

## Assistant

Черновик совпадает с кодом по поведению. Время в нём другое — поставлю 4 ч 4 мин и сохраню README.

### Tool Edit File V2

### Tool Edit File V2

## Assistant

Сборка схемы `test` — по шагу она нужна до коммита.

### Tool Run Terminal Command V2

### Tool Run Terminal Command V2

### Tool Run Terminal Command V2

### Tool Run Terminal Command V2

### Tool Run Terminal Command V2

## Assistant

Шаг 9 готов. `README.md` лежит в корне, время — **4 ч 4 мин.** Сборка схемы `test` прошла, коммит `51109dd` — `Add README.`

Разделы «Сделано» и «Как проверяли» с кодом совпадают, текст черновика я не менял.

- Несколько чатов, свайп «Удалить», история после перезапуска и удаление пустого чата есть.
- Ответ идёт потоком. До первого фрагмента — три точки. «Стоп» отменяет запрос и сохраняет уже пришедший текст.
- «Нет сети», «Кончился лимит API» и «Не удалось получить ответ» дают «Повторить». Вопрос без ответа после перезапуска показывается как «Ответ не получен» с той же кнопкой.
- Прокрутка следует за ответом только у нижнего края. Разметка ответа — жирный, курсив и код в строке. Таймаут ожидания данных — 15 с. Превью лимита подставляет HTTP 429. Повтор не создаёт вторую копию сообщения пользователя.
- Открытого ключа по `gsk_` в исходниках и истории git нет. В `ai-logs/05-step3.md` эта строка встречается один раз как шаблон прошлого поиска, не как ключ.

Пункт про повтор после обрывка ответа тоже совпадает с кодом и с планом: обрывок остаётся, новый ответ пишется следующим сообщением. Это не дефект шага, поэтому код не менялся.