## Оркестрация группой Docker-контейнеров на примере Docker Compose

### Задача 1

<details><summary>Описание задачи 1</summary>
Создайте собственный образ любой операционной системы (например ubuntu-20.04) с помощью Packer (инструкция).
Чтобы получить зачёт, вам нужно предоставить скриншот страницы с созданным образом из личного кабинета YandexCloud.
</details>

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/05-virt-04-docker-compose/lab_05-virt-04-docker-compose_img1.png)


### Задача 2

<details><summary>Описание задачи 2</summary>
2.1. Создайте вашу первую виртуальную машину в YandexCloud с помощью web-интерфейса YandexCloud.

2.2.* (Необязательное задание)
Создайте вашу первую виртуальную машину в YandexCloud с помощью Terraform (вместо использования веб-интерфейса YandexCloud). Используйте Terraform-код в директории (src/terraform).

Чтобы получить зачёт, вам нужно предоставить вывод команды terraform apply и страницы свойств, созданной ВМ из личного кабинета YandexCloud.
</details>

* Создайте вашу первую виртуальную машину в YandexCloud с помощью web-интерфейса YandexCloud:

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/05-virt-04-docker-compose/lab_05-virt-04-docker-compose_img2.png)

* Создайте вашу первую виртуальную машину в YandexCloud с помощью Terraform:

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/05-virt-04-docker-compose/lab_05-virt-04-docker-compose_img3.png)

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/05-virt-04-docker-compose/lab_05-virt-04-docker-compose_img4.png)


### Задача 3

<details><summary>Описание задачи 3</summary>
С помощью Ansible и Docker Compose разверните на виртуальной машине из предыдущего задания систему мониторинга на основе Prometheus/Grafana. Используйте Ansible-код в директории (src/ansible).

Чтобы получить зачёт, вам нужно предоставить вывод команды "docker ps" , все контейнеры, описанные в docker-compose, должны быть в статусе "Up".
</details>

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/05-virt-04-docker-compose/lab_05-virt-04-docker-compose_img5.png)


### Задача 4

<details><summary>Описание задачи 4</summary>
Откройте веб-браузер, зайдите на страницу http://<внешний_ip_адрес_вашей_ВМ>:3000.
Используйте для авторизации логин и пароль из .env-file.
Изучите доступный интерфейс, найдите в интерфейсе автоматически созданные docker-compose-панели с графиками(dashboards).
Подождите 5-10 минут, чтобы система мониторинга успела накопить данные.
Чтобы получить зачёт, предоставьте:

скриншот работающего веб-интерфейса Grafana с текущими метриками
</details>

![Скриншот](https://github.com/aleksey-raevich/devops-netology/blob/master/virt-homeworks/05-virt-04-docker-compose/lab_05-virt-04-docker-compose_img6.png)
