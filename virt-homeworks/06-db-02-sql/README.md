## SQL

### Задача 1

<details><summary>Описание задачи 1</summary>
Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose-манифест.
</details>

Содержимое файла docker-compose:
```text
version: '3.6'

volumes:
  data: {}
  backup: {}

services:
  postgres:
    image: postgres:12
    container_name: psql
    ports:
      - "0.0.0.0:5432:5432"
    volumes:
      - data:/var/lib/postgresql/data
      - backup:/media/postgresql/backup
    environment:
      POSTGRES_USER: "admin"
      POSTGRES_PASSWORD: "admin"
      POSTGRES_DB: "test_db"
    restart: always
```
Запуск и подключение к БД:
```text
docker-compose up -d
export PGPASSWORD=admin && psql -h localhost -U admin test_db
```

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/06-db-02-sql/lab_06-db-02-sql_img1.png)

### Задача 2
<details><summary>Описание задачи 2</summary>
В БД из задачи 1:

создайте пользователя test-admin-user и БД test_db;
в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже);
предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db;
создайте пользователя test-simple-user;
предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db.
Таблица orders:

id (serial primary key);
наименование (string);
цена (integer).
Таблица clients:

id (serial primary key);
фамилия (string);
страна проживания (string, index);
заказ (foreign key orders).
Приведите:

итоговый список БД после выполнения пунктов выше;
описание таблиц (describe);
SQL-запрос для выдачи списка пользователей с правами над таблицами test_db;
список пользователей с правами над таблицами test_db.
</details>

* итоговый список БД после выполнения пунктов выше:

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/06-db-02-sql/lab_06-db-02-sql_img2.png)

* описание таблиц (describe):

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/06-db-02-sql/lab_06-db-02-sql_img3.png)

* SQL-запрос для выдачи списка пользователей с правами над таблицами test_db:

```text
SELECT grantee, table_name, string_agg(privilege_type, ', ') AS privileges
FROM information_schema.role_table_grants
WHERE table_name in ('orders', 'clients')
GROUP BY grantee, table_name;
```

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/06-db-02-sql/lab_06-db-02-sql_img4.png)

* список пользователей с правами над таблицами test_db:

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/06-db-02-sql/lab_06-db-02-sql_img5.png)


### Задача 3
<details><summary>Описание задачи 3</summary>
Используя SQL-синтаксис, наполните таблицы следующими тестовыми данными:

Таблица orders

Наименование	цена
Шоколад	10
Принтер	3000
Книга	500
Монитор	7000
Гитара	4000
Таблица clients

ФИО	Страна проживания
Иванов Иван Иванович	USA
Петров Петр Петрович	Canada
Иоганн Себастьян Бах	Japan
Ронни Джеймс Дио	Russia
Ritchie Blackmore	Russia
Используя SQL-синтаксис:

вычислите количество записей для каждой таблицы.
Приведите в ответе:

- запросы,
- результаты их выполнения.
</details>

* Таблица orders:

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/06-db-02-sql/lab_06-db-02-sql_img6.png)

* Таблица clients:

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/06-db-02-sql/lab_06-db-02-sql_img7.png)


### Задача 4
<details><summary>Описание задачи 4</summary>
Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys, свяжите записи из таблиц, согласно таблице:

ФИО	Заказ
Иванов Иван Иванович	Книга
Петров Петр Петрович	Монитор
Иоганн Себастьян Бах	Гитара
Приведите SQL-запросы для выполнения этих операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод этого запроса.

Подсказка: используйте директиву UPDATE.
</details>

### Задача 5
<details><summary>Описание задачи 5</summary>
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).

Приведите получившийся результат и объясните, что значат полученные значения.
</details>

### Задача 6
<details><summary>Описание задачи 6</summary>
Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. задачу 1).

Остановите контейнер с PostgreSQL, но не удаляйте volumes.

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.
</details>