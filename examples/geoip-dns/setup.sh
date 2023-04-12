#!/bin/bash

set -e

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# shellcheck source=/dev/null
source "$here/../common.sh"

CLUSTER_NAME_DNS=edgedns
CLUSTER_EU=gslb-eu
CLUSTER_US=gslb-us

LIQO_CLUSTER_CONFIG_DNS_YAML="$here/manifests/edge-dns.yaml"
LIQO_CLUSTER_CONFIG_EU_YAML="$here/manifests/gslb-eu.yaml"
LIQO_CLUSTER_CONFIG_US_YAML="$here/manifests/gslb-us.yaml"

check_requirements "k3d"

delete_k3d_clusters "$CLUSTER_NAME_DNS" #"$CLUSTER_EU" "$CLUSTER_US"

create_k3d_cluster "$CLUSTER_NAME_DNS" "$LIQO_CLUSTER_CONFIG_DNS_YAML"
#create_k3d_cluster "$CLUSTER_EU" "$LIQO_CLUSTER_CONFIG_EU_YAML"
#create_k3d_cluster "$CLUSTER_US" "$LIQO_CLUSTER_CONFIG_US_YAML"

KUBECONFIG_DNS=$(get_k3d_kubeconfig $CLUSTER_NAME_DNS)
#KUBECONFIG_EU=$(get_k3d_kubeconfig $CLUSTER_EU)
#KUBECONFIG_US=$(get_k3d_kubeconfig $CLUSTER_US)


# Ensure Helm Repos

helm repo add k8gb https://www.k8gb.io &> /dev/null
helm repo add coredns https://coredns.github.io/helm &> /dev/null
helm repo add nginx-stable https://kubernetes.github.io/ingress-nginx &> /dev/null
helm repo add podinfo https://stefanprodan.github.io/podinfo &> /dev/null
helm repo add metallb https://metallb.github.io/metallb  &> /dev/null

helm repo update &> /dev/null


# Deploy Core DNS server

# info "Deploying Core DNS server..."

install_coredns_server "$KUBECONFIG_DNS"

# fail_on_error "kubectl apply -f $here/manifests/edge/ --kubeconfig=${KUBECONFIG_EDGE_DNS}" "Failed to deploy bind server"
# DNS_IP=$(kubectl get nodes --selector=node-role.kubernetes.io/master -o jsonpath='{$.items[*].status.addresses[?(@.type=="InternalIP")].address}' --kubeconfig="${KUBECONFIG_EDGE_DNS}")

# success_clear_line "Bind server has been deployed."

# # Deploy on cluster gslb-eu

# install_k8gb "$KUBECONFIG_1" "eu" "us" "$DNS_IP"
# install_ingress_nginx "$KUBECONFIG_1" "k8gb" "$here/manifests/values/nginx-ingress.yaml" "4.0.15"
# install_liqo_k3d "gslb-eu" "$KUBECONFIG_1" "10.40.0.0/16" "10.30.0.0/16"

# install_k8gb "$KUBECONFIG_2" "us" "eu" "$DNS_IP"
# install_ingress_nginx "$KUBECONFIG_2" "k8gb" "$here/manifests/values/nginx-ingress.yaml" "4.0.15"
# install_liqo_k3d "gslb-us" "$KUBECONFIG_2" "10.40.0.0/16" "10.30.0.0/16"
