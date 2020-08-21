#!/bin/bash

exec 3> `basename "$0"`.trace
BASH_XTRACEFD=3

set -ex

mkdir /etc/docker/
cat << EOF > /etc/docker/daemon.json
{ "insecure-registries": ["${REGISTRY}"] }
EOF
# Start Docker Daemon (and set a trap to stop it once this script is done)
echo 'DOCKER_OPTS="--data-root /scratch/docker --max-concurrent-downloads 10"' >/etc/default/docker
service docker start
service docker status
trap 'service docker stop' EXIT
sleep 10

pushd fissile-linux
tar xfv fissile-*.tgz
popd

VERSION=$(cat release/version)

docker pull "${STEMCELL_REPOSITORY}"

if [ ! -e release/sha1 ]; then
  # Calculate sha1sum if the resource is a file from s3. bosh.io resources provide the checksum automatically
  SHA1=$(sha1sum release/*gz | cut -f1 -d ' ' )
else
  SHA1=$(cat release/sha1)
fi

fissile-linux/fissile build release-images --stemcell="${STEMCELL_REPOSITORY}" --name="${RELEASE_NAME}" --version="${VERSION}" --sha1="$SHA1" --url="$(cat release/url)"

BUILT_IMAGE=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v "$STEMCELL_REPOSITORY" | head -1)
docker tag "${BUILT_IMAGE}" "${REGISTRY}/${BUILT_IMAGE}"
docker push "${REGISTRY}/${BUILT_IMAGE}"
