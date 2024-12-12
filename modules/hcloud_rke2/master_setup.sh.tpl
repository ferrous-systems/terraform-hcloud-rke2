#!/bin/bash -e

SUPERVISOR_URL=https://${lb_ip}:9345
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
tls-san:
  - ${api}
  - ${lb_ip}
  - ${lb_ext_v4}
  - ${lb_ext_v6}
EOF

mkdir -p /var/lib/rancher/rke2/server/manifests
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

umask 0022

cat <<EOF >/etc/multipath.conf
defaults {
    user_friendly_names yes
}
blacklist {
    devnode "^sd[a-z0-9]+"
}
EOF
systemctl restart multipathd.service

curl -sSfL https://get.rke2.io/ | INSTALL_RKE2_METHOD=tar INSTALL_RKE2_TYPE=server INSTALL_RKE2_VERSION="${rke2_version}" sh -
systemctl enable rke2-server.service
%{ if !initial }
for ((i = 0; i < 30; i++)); do
    curl -ksSfL -u 'node:${token}' $SUPERVISOR_URL/v1-rke2/readyz && break
    sleep 10
done

sleep 30
%{ endif }
systemctl start rke2-server.service && \
    sed -i -e 's/^# *//' /etc/rancher/rke2/config.yaml
