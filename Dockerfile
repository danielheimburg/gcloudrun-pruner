FROM --platform=linux/amd64 google/cloud-sdk:alpine

COPY run.sh /usr/bin/
RUN chmod +x /usr/bin/run.sh

ENTRYPOINT [ "run.sh" ]
