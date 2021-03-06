## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде
- Склады и автомобильные дороги для логистической компании
- Генеалогические деревья
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации
- Отношения клиент-покупка для интернет-магазина

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

**Ответ**

- Электронные чеки в json виде

Подойдет NoSQL документно-ориентироанная БД, например, MongoDB, т.к. поддерживает формат JSON

- Склады и автомобильные дороги для логистической компании

Графовая  СУБД. Дороги -грани, склады-узлы

- Генеалогические деревья

Иерархическая СУБД, её структура уже сродни  дереву со связью родитель-потомок

- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации

NoSQL СУБД ключ-значение. Пример Redis. Такие БД поддерживают TTL и укладываются в концепцию кэширования данных.

- Отношения клиент-покупка для интернет-магазина

Реляционная СУБД,  т.к. отношения клиент-товар-покупка легко представляюся в совокупности таблиц с ссылкамт друг на друга.
## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)
- При сетевых сбоях, система может разделиться на 2 раздельных кластера
- Система может не прислать корректный ответ или сбросить соединение

А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

**Ответ**

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)

`AP` ` PA/EL `- Т.к. запись асинхронная, данные на  узлах могут быть несогласованными, но в любом случае доступны в различных вариантах на одинаковые запросы.

- При сетевых сбоях, система может разделиться на 2 раздельных кластера

`AP`  `PA/EL ` - В данной системе после сетевого разделения каждый кластер  становится самостоятельной единицей, но продолжает отвечать на запросы. Данные могут быть рассогласоваными.

- Система может не прислать корректный ответ или сбросить соединение

`CP` `PC/EС ` - В случае сетевого разделения система не отвечает на запросы. Возвращаются только согласованные ответы.




## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

**Ответ**

Мое мнение - не могут, т. к. в построении обозначенных моделей  участвуют взаимоисключающие принципы. ACID на первую ступень ставит надежность данных, чем  с легкостью жертвует BASE в угоду быстродействия 

## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/).
Что это за система? Какие минусы выбора данной системы?

**Ответ**

СУБД Redis. К минусам можно отнести:

Redis хранит данные в оперативной памяти, поэтому не подходит для систем где критична надежность. 
Механизм Pub/Sub не обеспечивает доставку сообщений вне подписки.
При скорости получения данных подписчиком ниже скорости   публикации  часть информации может теряться по причине переполнения буфера.


---
