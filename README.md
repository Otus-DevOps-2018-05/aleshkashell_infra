# aleshkashell_infra
aleshkashell Infra repository

Инстанс с запущенным приложением:
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=/home/a.sheludchenkov/otus/aleshkashell_infra/startup.sh

Правило файервола
gcloud compute firewall-rules create default-puma-server --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server

testapp_IP=104.155.93.61
testapp_port=9292
