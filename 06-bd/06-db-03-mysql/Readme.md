# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

**Ответ**

```
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

**Ответ**

```
mysql> SELECT * FROM orders WHERE price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)

```

В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней
- количество попыток авторизации - 3
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

**Ответ**

```
CREATE USER
  'test'@'localhost' IDENTIFIED WITH mysql_native_password
                                   BY 'test-pass'
  WITH MAX_QUERIES_PER_HOUR 100
  PASSWORD EXPIRE INTERVAL 180 DAY
  FAILED_LOGIN_ATTEMPTS 3
  ATTRIBUTE '{"fname": "James", "lname": "Pretty"}';
```
Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

**Ответ**

```
GRANT SELECT ON  test_db.* TO  'test'@'localhost'
```

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и
**приведите в ответе к задаче**.

**Ответ**

```
mysql> select * from  INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER = 'test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)

```


## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

**Ответ**
```
mysql> SHOW TABLE STATUS FROM  test_db;
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2022-02-25 17:03:03 | 2022-02-25 17:03:03 | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.00 sec)

```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

**Ответ**

```
mysql> SHOW PROFILES;
+----------+------------+----------------------------------------+
| Query_ID | Duration   | Query                                  |
+----------+------------+----------------------------------------+
|        1 | 0.00042150 | SELECT * FROM orders WHERE price > 300 |
|        2 | 0.00241275 | SHOW TABLE STATUS FROM  test_db        |
|        3 | 0.21295675 | ALTER TABLE orders ENGINE = MyISAM     |
|        4 | 0.00324850 | SHOW TABLE STATUS FROM  test_db        |
|        5 | 0.00043375 | SELECT * FROM orders WHERE price > 300 |
|        6 | 0.12690000 | ALTER TABLE orders ENGINE = InnoDB     |
|        7 | 0.00050650 | SELECT * FROM orders WHERE price > 300 |
|        8 | 0.00323750 | SHOW TABLE STATUS FROM  test_db        |
+----------+------------+----------------------------------------+
8 rows in set, 1 warning (0.00 sec)
```

## Задача 4

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

**Ответ**

```
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL


innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DSYNC
innodb_file_per_table = 1
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 310M
innodb_log_file_size = 100M


!includedir /etc/mysql/conf.d/
```

---


