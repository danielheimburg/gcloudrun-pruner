#!/usr/bin/env bash

set -euo pipefail

_term() {
  rm *-rev.txt
  exit 0
}

trap _term TERM INT

if [ -f .env ]
then
  export $(cat .env | xargs)
fi

echo "running job"

services=$(gcloud --project=${PROJECT} run services list --format="value(metadata.name)")

for service in $services; do

    gcloud --project=${PROJECT} run revisions list --service=${service} --region=europe-west9 --filter="metadata.creationTimestamp<-${DELETE_OLDER}" --sort-by=metadata.creationTimestamp --format="value(metadata.name, status.imageDigest)" > ${service}-rev.txt

    if [ $(cat ${service}-rev.txt|wc -l) -ge ${KEEP} ]; then
        echo "cleaning ${service}"
        while read -r line; do
          read -r revision digest <<< $line
          gcloud --project=${PROJECT} --quiet run revisions delete ${revision}
          gcloud --project=${PROJECT} --quiet container images delete --force-delete-tags ${digest};
        done < ${service}-rev.txt
    fi
    rm ${service}-rev.txt
done

echo "job done"