#!/bin/bash -e

apt-get update -y
apt-get install -y nfs-common

systemctl stop apparmor.service
systemctl disable apparmor.service
systemctl stop multipathd.socket
systemctl disable multipathd.socket
systemctl stop multipathd.service
systemctl disable multipathd.service

cat <<EOF >/etc/modules-load.d/dm-crypt.conf
dm-crypt
EOF
modprobe dm-crypt

mkdir -p /var/lib/rancher/rke2/server/manifests

%{ if cni=="cilium" }
cat <<EOF >/var/lib/rancher/rke2/server/manifests/rke2-cilium-config.yaml
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-cilium
  namespace: kube-system
spec:
  valuesContent: |-
    routingMode: native
    ipv4NativeRoutingCIDR: ${cluster_cidr}
    operator:
      tolerations:
        - key: node-role.kubernetes.io/control-plane
          operator: Exists
        - key: node-role.kubernetes.io/master
          operator: Exists
        - key: node.kubernetes.io/not-ready
          operator: Exists
        - key: node.cloudprovider.kubernetes.io/uninitialized
          operator: Exists
EOF
%{ endif }

cat <<EOF >/var/lib/rancher/rke2/server/manifests/rke2-ingress-nginx-config.yaml
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-ingress-nginx
  namespace: kube-system
spec:
  valuesContent: |-
    controller:
      nodeSelector:
        kubernetes.io/os: linux
        node-role.kubernetes.io/master: "true"
      config:
        use-forwarded-headers: "true"
EOF

SUPERVISOR_URL=https://${lb_ip}:9345

%{ if !initial }
for ((i = 0; i < 30; i++)); do
    curl -ksSfL -u 'node:${token}' $SUPERVISOR_URL/v1-rke2/readyz && break
    sleep 10
done

sleep 30
%{ endif }

NODE_IP=`ip route get ${lb_ip} | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}'`

umask 0077

mkdir -p /etc/rancher/rke2
cat <<EOF >/etc/rancher/rke2/config.yaml
%{ if initial }
#server: $SUPERVISOR_URL
%{ else }
server: $SUPERVISOR_URL
%{ endif }
token: "${token}"
node-ip: $NODE_IP
cloud-provider-name: external
%{ if cni=="cilium" }
cni: cilium
%{ endif }
cluster-cidr: ${cluster_cidr}
service-cidr: ${service_cidr}
tls-san:
  - ${api}
  - ${lb_ip}
  - ${lb_ext_v4}
  - ${lb_ext_v6}
EOF

# curl -sSfL https://get.rke2.io/ | \
#     INSTALL_RKE2_METHOD=tar \
#     INSTALL_RKE2_TYPE=server \
#     INSTALL_RKE2_VERSION="${rke2_version}" sh -

curl -sSfL https://get.rke2.io/ | \
    INSTALL_RKE2_TYPE=server \
    INSTALL_RKE2_VERSION="${rke2_version}" sh -

umask 0022

systemctl enable rke2-server.service
systemctl start rke2-server.service && \
    sed -i -e 's/^# *//' /etc/rancher/rke2/config.yaml
