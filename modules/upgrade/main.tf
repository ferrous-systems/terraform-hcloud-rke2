data "http" "crd" {
    url = "https://github.com/rancher/system-upgrade-controller/releases/download/v${var.system_upgrade_controller_version}/crd.yaml"
}

data "kubectl_file_documents" "crd" {
    content = data.http.crd.response_body
}

data "http" "controller" {
    url = "https://github.com/rancher/system-upgrade-controller/releases/download/v${var.system_upgrade_controller_version}/system-upgrade-controller.yaml"
}

data "kubectl_file_documents" "controller" {
    content = data.http.controller.response_body
}

resource "kubectl_manifest" "crd" {
    for_each  = data.kubectl_file_documents.crd.manifests
    yaml_body = each.value
}

resource "kubectl_manifest" "controller" {
    depends_on = [kubectl_manifest.crd]
    for_each   = data.kubectl_file_documents.controller.manifests
    yaml_body  = each.value
}

resource "kubectl_manifest" "master_plan" {
    depends_on = [kubectl_manifest.controller]
    yaml_body  = <<-EOT
    apiVersion: upgrade.cattle.io/v1
    kind: Plan
    metadata:
      namespace: system-upgrade
      name: master-plan
      labels:
        rke2-upgrade: master
    spec:
      concurrency: 1
      nodeSelector:
        matchExpressions:
          - { key: rke2-upgrade, operator: NotIn, values: [ "disabled", "false" ] }
          - { key: node-role.kubernetes.io/master, operator: In, values: [ "true" ] }
      tolerations:
        - key: "CriticalAddonsOnly"
          operator: "Equal"
          value: "true"
          effect: "NoExecute"
      serviceAccountName: system-upgrade
      drain:
        ignoreDaemonSets: true
      upgrade:
        image: rancher/rke2-upgrade
      version: ${var.rke2_version}
    EOT
}

resource "kubectl_manifest" "agent_plan" {
    depends_on = [kubectl_manifest.controller]
    yaml_body  = <<-EOT
    apiVersion: upgrade.cattle.io/v1
    kind: Plan
    metadata:
      namespace: system-upgrade
      name: agent-plan
      labels:
        rke2-upgrade: agent
    spec:
      concurrency: 1
      nodeSelector:
        matchExpressions:
          - { key: rke2-upgrade, operator: NotIn, values: [ "disabled", "false" ] }
          - { key: node-role.kubernetes.io/master, operator: NotIn, values: [ "true" ] }
      prepare:
        args:
          - prepare
          - master-plan
        image: rancher/rke2-upgrade
      serviceAccountName: system-upgrade
      drain:
        force: true
      upgrade:
        image: rancher/rke2-upgrade
      version: ${var.rke2_version}
    EOT
}
