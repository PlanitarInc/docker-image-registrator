
The container runs [registrator](https://github.com/PlanitarInc/registrator/).

Run in `dev` cluster:

```sh
docker run -d -h $HOSTNAME \
    -v /var/run/docker.sock:/tmp/docker.sock \
    -e DOCKER_HOST="unix:///tmp/docker.sock" \
    -e SERVICE_IGNORE="" \
    planitar/registrator skydns2:///dev.plntr.ca \
    -ttl 30 -refresh-ttl 10
```

To run container that should be ignored by `registrator`
(should not be registered), define `SERVICE_IGNORE` envvar:

```sh
docker run -d -P \
    -e SERVICE_IGNORE="" \
    planitar/base bash
```

Any other running container is going to be registered as:
  - DNS: `<service-id>.<service-name>.dev.plntr.ca`
  - etcd: `/skydns/ca/plntr/dev/<service-name>/<service-id>
    = {"host":"<HOST-IP>", "port":<PUBLISHED-PORT>}`

where:
  - `<service-id>` defaults to
    `<hostname>:<container-name>:<internal-port>[:udp if udp]`;
    can be specified using `SERVICE_ID` envvar
  - `<service-name>` defaults to
    `<basename(container-image)>[-<internal-port> if >1 published ports]`;
    can be specified using `SERVICE_NAME` envvar

E.g. registering `redis.0` container as instance `00` of `redis` service:

```sh
docker run -d -p 6379:6379 --name redis.0 \
    -e SERVICE_NAME="redis" \
    -e SERVICE_ID="00" \
    planitar/redis bash
```
