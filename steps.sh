helm repo add jenkins https://charts.jenkins.io
helm repo update

ssh node01 << EOD
sudo mkdir -p /mnt/data/jenkins
sudo chown -R 1000:1000 /mnt/data/jenkins
sudo chmod -R 775 /mnt/data/jenkins
EOD

kubectl apply -f ./jenkins/templates/pv.yaml
kubectl apply -f ./jenkins/templates/pvc.yaml
helm install jenkins jenkins/jenkins -f ./jenkins/values.yaml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install monitoring prometheus-community/kube-prometheus-stack  # fix: was "kube-prometheus-stac"

# Wait for Prometheus stack CRDs and resources to be ready before proceeding
echo "Waiting for monitoring stack to be ready..."
kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/name=grafana \
  -n default \
  --timeout=120s

kubectl apply -f ./Grafana/exporter.yaml
kubectl apply -f ./Grafana/monitor.yaml
kubectl apply -f ./Grafana/svc.yaml

kubectl create secret generic postgres-exporter-secret \
  --from-literal=DATA_SOURCE_NAME="postgresql://appuser:apppassword@postgress-custom-postgres:5432/appdb?sslmode=disable"

# Retrieve Grafana password (only after monitoring stack is confirmed up)
kubectl get secret monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
echo ""
