# fissile-build-image

Bash scripts and Concourse tasks for building Docker Images from BOSH releases using Fissile.

An example pipeline is included.

## To push Docker Images to Dockerhub
Use the `build-release-dockerhub` job in the `pipeline.yml` as a template.

You will need to add a resource to the `pipeline.yml` for your release, and update the following values in the `build-release-dockerhub` job accordingly:
```
RELEASE_NAME:
REGISTRY_OR_ORG:
```

You will also need to provide the `DOCKER_TEAM_USERNAME` and `DOCKER_TEAM_PASSWORD` via a secrets manager or via the `fly` cli when setting the pipeline.

## To push Docker Images to a Private Registry
Use the `build-release-registry` job in the `pipeline.yml` as a template.

You will need to add a resource to the `pipeline.yml` for your release, and update the following values in the `build-release` pipeline job accordingly:
```
RELEASE_NAME:
REGISTRY_OR_ORG:
```
