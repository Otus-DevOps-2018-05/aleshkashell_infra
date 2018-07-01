# aleshkashell_infra
aleshkashell Infra repository

## Инстанс с запущенным приложением:
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=/home/a.sheludchenkov/otus/aleshkashell_infra/startup.sh

## Правило файервола
gcloud compute firewall-rules create default-puma-server --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server

testapp_IP=104.155.93.61
testapp_port=9292

## Подключение к someinternalhost:
ssh -o ProxyCommand="ssh -W %h:%p appuser@35.205.217.71" -i ~/.ssh/appuser -A appuser@10.132.0.3

## Для подключения к someinternalhost по алиасу добавить в ~/.ssh/config
Host someinternalhost
        Hostname 10.132.0.3
        User appuser
        ProxyCommand ssh -W %h:%p appuser@35.205.217.71

## Подключаться командой:
ssh someinternalhost

## Подключение к внутренней сети:
bastion_IP = 35.205.217.71
someinternalhost_IP = 10.132.0.2
