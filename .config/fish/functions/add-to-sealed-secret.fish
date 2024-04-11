function add-to-sealed-secret
echo -n $argv[2] \
    | kubectl create secret generic xxx --dry-run=client --from-file=$argv[1]=/dev/stdin -o json \
    | kubeseal --controller-namespace=kube-system --controller-name=sealed-secrets-controller --format yaml --merge-into sealed-secrets.yaml

end
