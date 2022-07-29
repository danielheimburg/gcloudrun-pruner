#!/usr/bin/env bash

set -euo pipefail

_echoerr() {
  1>&2 echo $@
}

_term() {
  _echoerr "bye"
  exit 0
}

trap _term TERM INT

echo "running job"

services=$(gcloud run services list --format="value(metadata.name)")

for service in $services; do

    gcloud run revisions list --service=${service} --region=europe-west9 --project=${PROJECT} --filter="metadata.creationTimestamp<-${DELETE_OLDER}" --sort-by=metadata.creationTimestamp --format="value(metadata.name, status.imageDigest)" > ${service}-rev.txt

    if [ $(cat ${service}-rev.txt|wc -l) -ge ${KEEP} ]; then
        while read -r line; do
        read -r revision digest <<< $line
        gcloud --quiet run revisions delete ${revision}
        gcloud --quiet container images delete --force-delete-tags ${digest};
        done < ${service}-rev.txt
    fi

    rm ${service}-rev.txt
done

echo "job done"