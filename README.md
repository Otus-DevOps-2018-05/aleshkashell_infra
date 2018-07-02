# aleshkashell_infra
aleshkashell Infra repository

# Table of content
- [Cloud bastion](#cloud-bastion)
- [Cloud testapp](#cloud-testapp)
- [Packer base](#packer-base)

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