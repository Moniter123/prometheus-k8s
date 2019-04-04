# use prometheus-operator install Prometheus for K8S

## INSTALL步骤文档说明(离线安装)

* 1. 准备含有相关镜像的本地registry和harbor仓库

* 2. 创建namespace(如: namespace=monitoring) --- 参见deploy.sh
     kubectl create namespace monitoring

* 3. 配置NFS地址(NFS服务端共享目录777授权)和持久化目录 --- 参见deploy.sh
     vim prometheus-pvc.yaml
     vim grafana-pvc.yaml

* 4. 创建prometheus和grafana的pvc --- 参见deploy.sh
     kubectl create -f ./prometheus-pvc.yaml
     kubectl create -f ./grafana-pvc.yaml

* 5. 修改namespace和镜像仓库变量配置(in deploy.sh) --- 参见deploy.sh

* 6. 取消执行命令的注释(in deploy.sh) --- 参见deploy.sh

* 7. sh deploy.sh

* 8. 验证安装结果
     kubectl get pods,svc,deployment,job,daemonset,ingress,configmap,servicemonitor,customresourcedefinitions --namespace=monitoring

* 9. 配置ingress for grafana/prometheus/alertmanager(可选)

