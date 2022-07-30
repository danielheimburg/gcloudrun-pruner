#!/usr/bin/env bash

set -euo pipefail

_term() {
  rm ${TMPDIR}/*-rev.txt
  exit 0
}

trap _term TERM INT

if [ -f .env ]
then
  export $(cat .env | xargs)
fi

GCLOUDARGS="--project=${PROJECT} --verbosity=error --quiet"
TMPDIR="/tmp"

echo "running job.."

services=$(gcloud ${GCLOUDARGS} run services list --format="value(metadata.name)")

for service in $services; do

    gcloud ${GCLOUDARGS} run revisions list --service=${service} --region=europe-west9 --filter="metadata.creationTimestamp<-${DELETE_OLDER}" --sort-by=metadata.creationTimestamp --format="value(metadata.name, status.imageDigest)" > ${TMPDIR}/${service}-rev.txt

    if [ $(cat ${TMPDIR}/${service}-rev.txt|wc -l) -ge ${KEEP} ]; then
        echo "cleaning ${service}"
        while read -r line; do
          read -r revision digest <<< $line
          gcloud ${GCLOUDARGS} run revisions delete ${revision}
          gcloud ${GCLOUDARGS} container images delete --force-delete-tags ${digest};
        done < ${service}-rev.txt
    else
        echo "no cleanup needed in ${service}"
    fi
    rm ${TMPDIR}/${service}-rev.txt
done

echo "job done"