# Google Cloud Run & Container Pruner

Super simple script that does the job. Either run the script locally or deploy the script with the Dockerfile. Cloud Run Jobs preview is only available in europe-west9 currenly. Use the following environment variables:


Delete revisions / containers older than 2 days - https://en.wikipedia.org/wiki/ISO_8601
```
DELETE_OLDER=P2D
```
Always keep this amount of revisions / containers per service
```
KEEP=3
```
Region (for cloud run jobs) and projectname
```
REGION=
PROJECT=
```

Contributions welcome!