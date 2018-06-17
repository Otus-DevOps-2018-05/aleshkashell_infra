# aleshkashell_infra
aleshkashell Infra repository

Подключение к someinternalhost:
ssh -o ProxyCommand="ssh -W %h:%p appuser@35.205.217.71" -i ~/.ssh/appuser -A appuser@10.132.0.3

Для подключения к someinternalhost по алиасу добавить в ~/.ssh/config
Host someinternalhost
        Hostname 10.132.0.3
        User appuser
        ProxyCommand ssh -W %h:%p appuser@35.205.217.71

Подключаться командой:
ssh someinternalhost

Подключение к внутренней сети:
bastion_IP = 35.205.217.71
someinternalhost_IP = 10.132.0.2
