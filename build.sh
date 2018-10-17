#!/usr/bin/env bash

set -e

docker version
docker-compose version

WORK_DIR=$(pwd)

if [ -n "${CI_OPT_DOCKER_REGISTRY_PASS}" ] && [ -n "${CI_OPT_DOCKER_REGISTRY_USER}" ]; then echo ${CI_OPT_DOCKER_REGISTRY_PASS} | docker login --password-stdin -u="${CI_OPT_DOCKER_REGISTRY_USER}" docker.io; fi

export IMAGE_PREFIX=${IMAGE_PREFIX:-cirepo/};
export IMAGE_NAME=${IMAGE_NAME:-rvm-ruby}
export IMAGE_TAG=${IMAGE_ARG_NODE_VERSION:-2.4.1}-bionic
if [ "${TRAVIS_BRANCH}" != "master" ]; then export IMAGE_TAG=${IMAGE_TAG}-SNAPSHOT; fi

# Build image
if [[ "$(docker images -q ${IMAGE_PREFIX}${IMAGE_NAME}:${IMAGE_TAG} 2> /dev/null)" == "" ]]; then
    docker-compose build image
fi

# Build dumper image
docker save ${IMAGE_PREFIX}${IMAGE_NAME}:${IMAGE_TAG} > dumper/docker/image.tar
docker-compose build dumper
docker rm -fv broken_files || echo 'container broken_files not exists'
docker run --name broken_files tmp/dumper:latest /home/ubuntu/data/broken_files.sh
docker commit broken_files tmp/dumper:latest
docker rm -fv broken_files

# Build archive image
docker-compose build archive

docker-compose push image
docker-compose push archive
