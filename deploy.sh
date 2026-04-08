#!/bin/bash
# Manual deploy script for ArgoCD on local cluster
# Usage: bash deploy.sh

set -e

echo "=== Verifying cluster access ==="
kubectl cluster-info

echo ""
echo "=== Deploying ArgoCD ==="
kubectl apply -f base/namespace.yaml
kubectl apply -n argocd -f base/install.yaml --server-side --force-conflicts
kubectl apply -f base/argocd-server-nodeport.yaml

echo ""
echo "=== Waiting for rollout ==="
kubectl -n argocd rollout status deployment/argocd-server --timeout=180s
kubectl -n argocd rollout status deployment/argocd-repo-server --timeout=180s
kubectl -n argocd rollout status deployment/argocd-redis --timeout=180s

echo ""
echo "=== Deploying Applications ==="
kubectl apply -f apps/

echo ""
echo "=== Done ==="
kubectl -n argocd get applications
