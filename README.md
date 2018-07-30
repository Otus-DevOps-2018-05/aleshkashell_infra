# aleshkashell_infra  [![Build Status](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra)
aleshkashell Infra repository  

# Table of content
- [Cloud bastion](#cloud-bastion)   [![Build Status](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra.svg?branch=cloud-bastion)](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra)
- [Cloud testapp](#cloud-testapp)   [![Build Status](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra.svg?branch=cloud-testapp)](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra)
- [Packer base](#packer-base)   [![Build Status](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra.svg?branch=packer-base)](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra)
- [Terraform-1](#terraform-1)   [![Build Status](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra.svg?branch=terraform-1)](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra)
- [Terraform-2](#terraform-2)   [![Build Status](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra.svg?branch=terraform-2)](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra)
- [Ansible-1](#ansible-1)   [![Build Status](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra.svg?branch=ansible-1)](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra)
- [Ansible-2](#ansible-2)   [![Build Status](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra.svg?branch=ansible-2)](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra)
- [Ansible-3](#ansible-3)   [![Build Status](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra.svg?branch=ansible-3)](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra)
- [Ansible-4](#ansible-4)   [![Build Status](https://travis-ci.com/Otus-DevOps-2018-05/aleshkashell_infra.svg?branch=ansible-4)]

# Cloud bastion

## 1. Что было сделано
### Подключение к someinternalhost:
```
ssh -o ProxyCommand="ssh -W %h:%p appuser@35.205.217.71" -i ~/.ssh/appuser -A appuser@10.132.0.3
```
### Для подключения к someinternalhost по алиасу добавить в ~/.ssh/config
```
Host someinternalhost
        Hostname 10.132.0.3
        User appuser
        ProxyCommand ssh -W %h:%p appuser@35.205.217.71
```
### Подключаться командой:
```
ssh someinternalhost
```
## 2. Данные для проверки
```
bastion_IP = 35.205.217.71
someinternalhost_IP = 10.132.0.2
```

# Cloud testapp

## 1. Что было сделано
- развернуто приложение в gcp
- сделан скрипт авторазвертки приложения
- произведена настройка файервола
## 2. Проверить работоспособность:
- Перейти по ссылке http://104.155.93.61:9292/

# Packer base

## 1. Что было сделано
### Инстанс с запущенным приложением:
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=/home/a.sheludchenkov/otus/aleshkashell_infra/startup.sh
```
### Правило файервола
```
gcloud compute firewall-rules create default-puma-server --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server
```
## 2. Данные для проверки
```
testapp_IP=104.155.93.61
testapp_port=9292
```

# Terraform 1

## 1. Что было сделано
- Развернуто окружение с использованием terraform
- Определены переменные для параметров terraform
- Отформатированы файлы конфигурации terraform
- Добавален terraform.rfvars.example
- Добавлены ключи нескольких пользователей в метаданные проетка. Для указания нескольких ключей\пользователей, их необходимо разделять симвовлом переноса строки '\n'
- Добавлен ключ пользователя в метаданные проекта через интерфей web interface, который удалился при следующем запуске terraform, т.к. он не описан в коде.
- Добавлен http балансировщик нагрузки
- Добавлена возможность выбора количества виртуальных машин

## 2. Как запустить проект
```
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform plan
terrafom apply
```
## 3. Как проверить
- Перейти по адресу из команды
```
terraform output balancer_external_ip
```
# Terraform 2

## 1. Что было сделано
- Импортировано правило файервола в terraform
- Сделаны ссылки на атрибуты ресурсов
- Созданы отдельные модули для каждой ВМ
- Создан модуль с правилами файервола
- Настроено хранение state-файлов для prod и stage в удаленном backend. Система блокировок работает корректно.
- Добалены provisioners в модули для деплоя

## 2. Как запустить проект
```
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terrafom apply -auto-approve
```
## 3. Как проверить
- Перейти по адресу из команды и порту 9292
```
terraform output app_external_ip
```

# Ansible 1

## 1. Что сделано
- Создано окружение для ansible (кофигурация, инвентори, плейбук)
- Протестирована работа модулей и плейбуков. При повторном запуске плейбука в случае, если выполнять нечего, то результатом возврата будет "OK", иначе будут произведены изменения и будет возвращено "changed"
- Создан dynamic inventory и протестирована его корректность
## 2. Как проверить
- Запустить из директории ansible:
```
ansible-playbook clone.yml
```

# Ansible 2

## 1. Что сделано
- Настройка инстанса для приложения
- Произведен деплой приложения
- Изменены шаблоны packer и перепакованы образы
- Добавлен dynamic inventory с использованием gce.py
## 2. Как запустить проект
```
ansible-playbook site.yml
```
## 3. Как проверить
- Перейти по адресу http://'application ip':9292

# Ansible 3

## 1. Что сделано
- Созданы роли для приложения и БД
- Созданы окружения в ansible и определено окружение по умолчанию
- Переорганизованы плейбуки
- Добалено открытие 80 порта в терраформ
- Добавлена роль jdauphant.nginx
- Созданы зашифрованные credentials с помощью ansible-vault
- Настроено использование dynamic inventory
- Добавлены проверки в travis с использованием ansible-lint, tflint и packer. Проверки отрабатывают только для master и pull requests

## 2. Как запустить проект
- Из директории anbile:
```
ansible-playbook playbooks/site.yml
```
## 3. Как проверить
- Перейти по адресу http://'application ip':9292

# Ansible 4

## 1. Что сделано
- Установлен vagrant
- Произведено развертывание окружение с помощью vagrant
- Адаптированы роли ansible
- Произведена настройка проксирования nginx
- Установлено и опробовано molecule для тестирования роли db
- Создана проверка, что db слушает на порту
- Роли db и app использованы в packer'е.
- Роль db вынесена в отдельный репозиторий и подключения через requirements.yml
- К роли db подключен travisCI для автоматического прогона тестов
- К роли db сделан бейдж со статусом билда
- Сделано оповещние о статусей билда роли db в slack

## 2. Как запустить проект
- Из директории ansible
```
vagrant up
```

## 3. Как проверить
- Перейти по адресу http://10.10.10.20
