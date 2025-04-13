# Setup

## To add etc hosts

```bash
ozone -c pull-request run script/add_ip_to_hosts.sh
```

## Env vars

```dotenv
TF_VAR_linode_token
IVANTI_STATE_S3_SECRET_KEY
IVANTI_STATE_S3_ACCESS
```

Need to log into docker registry

Example docker tag: `docker.io/ozone2021/ivt-api:test`

main workding 