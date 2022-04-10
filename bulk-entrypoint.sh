#!/bin/bash
CREATE_SECRET_ON_COMPLETION=${NOTIFY_COMPLETE:-false}
SECRET_NAME=${SECRET_NAME:-longhorn-restore-complete}
SECRET_NAMESPACE=${SECRET_NAMESPACE:-longhorn-system}
if [ "$CREATE_SECRET_ON_COMPLETION" == "true" ]; then
    kubectl get secret $SECRET_NAME -n $SECRET_NAMESPACE &> /dev/null
    exit_status=$?
    if [ $exit_status -eq 1 ]; then
        python3 backup-restore-bulk.py && \
        kubectl create secret generic ${SECRET_NAME} -n $SECRET_NAMESPACE --from-literal=complete=true
    fi
else 
    python3 backup-restore-bulk.py
fi