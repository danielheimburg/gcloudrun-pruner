# Google Cloud Run & Container Pruner

Either run the script locally or deploy the script with the Dockerfile. Cloud Run Jobs is only available in europe-west9. Use the following environment variables

Delete revisions / containers older than https://en.wikipedia.org/wiki/ISO_8601
```
DELETE_OLDER=P2D
```
Always keep this amount of revisions / containers
```
KEEP=3
```
Region (for cloud run jobs) and projectname
```
REGION=
PROJECT=
```