helm repo add jenkins https://charts.jenkins.io
helm repo update
ssh node01 << EOF
sudo mkdir -p /mnt/data/jenkins
sudo chown -R 1000:1000 /mnt/data/jenkins
sudo chmod -R 775 /mnt/data/jenkins
EOF
