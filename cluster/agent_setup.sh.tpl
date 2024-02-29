#!/bin/bash -e

umask 0077
mkdir -p /etc/rancher/rke2
cat <<EOF >/etc/rancher/rke2/config.yaml
server: https://${lb_ip}:9345
token: "${cluster_token}"
EOF

umask 0022
curl -sfL https://get.rke2.io/ | INSTALL_RKE2_METHOD=tar INSTALL_RKE2_TYPE=agent INSTALL_RKE2_VERSION="${rke2_version}" sh -

systemctl enable rke2-agent.service
systemctl start rke2-agent.service
