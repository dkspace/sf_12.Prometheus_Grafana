# sf_12.Prometheus_Grafana

This is an exercise for DevOps training from SkillFactory.ru - DEVOPS

We have to configure virtual mashine#1 wtih Prometheus Server + Grafana for monitoring of virtual mashine#2 with installed nginx (Prometheus Node Exporter)


## deploy 

```shell
git clone https://github.com/dkspace/sf_12.Prometheus_Grafana
cd sf_12.Prometheus_Grafana

cd roles
git clone https://github.com/cloudalchemy/ansible-prometheus.git
cd ..
## to use ansible-prometheus role from developer we have to enable 'gather_facts: yes' in playlist and 'pip install jmespath'
pip install jmespath
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply
````

## Configure Grafana

In Grafana Data source Prometheus have to be configured (please refer to images folder) 

In Grafana : dashboard import , and insert id of dasboard #1860 


http://vm1ip:9090 <- Prometheus GUI

http://vm2ip:3000/ <- Grafana GUI admin:admin or admin:1qaz@WSX 


## links 

https://prometheus.io/docs/instrumenting/exporters/#http
https://github.com/prometheus/node_exporter
https://copr.fedorainfracloud.org/coprs/ibotty/prometheus-exporters/
https://grafana.com/grafana/download
https://grafana.com/docs/grafana/latest/getting-started/getting-started/
