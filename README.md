# Google Cloud Run & Container Pruner

Super simple script that does the job. Either run the script locally or deploy the script with the Dockerfile. You can run it with cloud run jobs but the preview is only available in europe-west9 currenly so make sure to set that region. Use the following environment variables:

Delete revisions / containers older than 2 days - https://en.wikipedia.org/wiki/ISO_8601
```
DELETE_OLDER=P2D
```
Always keep this amount of revisions / containers per service
```
KEEP=3
```
Region (for cloud run jobs) and project name
```
REGION=
PROJECT=
```

Contributions welcome!