k8 () {
    if [ -z "$K8_NAMESPACE" ]; then
        echo "First, set environment executing: [loc|stg|prd]-<app>"
        return
    fi

    alias k8-context="kubectl config get-contexts"
    alias k8-resources="kubectl get all -n $K8_NAMESPACE"
    alias k8-pods="kubectl get pods --namespace $K8_NAMESPACE"
    alias k8-restart="kubectl rollout restart deployment $K8_DEPLOYMENT --namespace $K8_NAMESPACE"
    alias k8-describe="kubectl describe deployment/$K8_DEPLOYMENT --namespace $K8_NAMESPACE"
    alias k8-deployments="kubectl get deployments --namespace $K8_NAMESPACE"
    alias k8-deployments-logs="kubectl logs deployment/$K8_DEPLOYMENT --all-containers=true --since=10m --follow --namespace $K8_NAMESPACE"
    alias k8-cronjobs="kubectl get cronjobs --namespace $K8_NAMESPACE"
    alias k8-rollout-history="kubectl rollout history deployment/$K8_DEPLOYMENT --namespace $K8_NAMESPACE"
}

k8-pod-logs () {
    if [ -z "$K8_NAMESPACE" ]; then
        echo "First, set environment executing: [loc|stg|prd]-<app>"
        return
    fi

    kubectl logs pod/$1 --follow --namespace $K8_NAMESPACE
}

k8-pod-ssh () {
    if [ -z "$K8_NAMESPACE" ]; then
        echo "First, set environment executing: [loc|stg|prd]-<app>"
        return
    fi

    kubectl exec --stdin --tty $1 --namespace $K8_NAMESPACE -- /bin/sh
}

k8-rollout() {
    if [ -z "$K8_NAMESPACE" ]; then
        echo "First, set environment executing: [loc|stg|prd]-<app>"
        return
    fi

    kubectl rollout undo deployment/$K8_DEPLOYMENT --to-revision=$1 --namespace $K8_NAMESPACE
}

k8-rollback() {
    if [ -z "$K8_NAMESPACE" ]; then
        echo "First, set environment executing: [loc|stg|prd]-<app>"
        return
    fi

    helm rollback $K8_DEPLOYMENT-release
}

k8-help() {
    echo -e "\033[0;32mCommands for: kubectl\033[0m"
    echo "kubectl config view"
    echo "kubectl config get-contexts"
    echo "kubectl config use-context <namespace>"
    echo "kubectl cluster-info"
    echo "kubectl get all --all-namespaces"
    echo "kubectl get all -n <namespace>"
    echo "kubectl get namespace"
    echo "kubectl get deployments --namespace <namespace>"
    echo "kubectl get pods --namespace <namespace>"
    echo "kubectl get jobs --namespace <namespace>"
    echo "kubectl logs deployment/<name-deployment> --all-containers=true --since=10m --follow --namespace <namespace>"
    echo "kubectl logs <pod-name> --namespace <namespace>"
    echo "kubectl describe deployment/<name-deployment> --namespace <namespace>"
    echo "kubectl exec --stdin --tty <pod-name> --namespace <namespace> -- /bin/bash"
    echo "kubectl exec --stdin --tty <pod-name> --container <container> --namespace <namespace> -- /bin/bash"
    echo "kubectl scale deployment <name-deployment> --replicas=<number> --namespace <namespace>"
    echo "kubectl rollout history deployment/<name-deployment> --namespace <namespace>"
    echo "kubectl rollout undo deployment/<name-deployment> --to-revision=<id> --namespace <namespace>"
    echo -e "\033[0;32mCommands for: helm\033[0m"
    echo "helm rollback <namespace>-release"
}
