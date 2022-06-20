#!/bin/bash

# ========================
#        PARAMETERS
# ========================
for i in "$@"
do
case $i in
    -v=*|--version=*)
    IDE_VERSION="${i#*=}"
    shift
    ;;
    -i=*|--ide=*)
    IDE_NAME="${i#*=}"
    shift
    ;;
    -u=*|--user=*)
    USER_NAME="${i#*=}"
    shift
    ;;
    -p=*|--password=*)
    USER_PASSWORD="${i#*=}"
    shift
    ;;
    -i=*|--image=*)
    IMAGE="${i#*=}"
    shift
    ;;
    -r=*|--registry=*)
    REGISTRY="${i#*=}"
    shift
    ;;
    *)
        # unknown option
    ;;
esac
done


# ========================
#      CONFIGURATION
# ========================

CONF_REGISTRY=registry.hub.docker.com
CONF_IMAGE=bmarsaud/jetbrains-backend
CONF_USER_NAME=dev
CONF_USER_PASSWORD=dev

if [[ -z $IDE_NAME ]]; then
    echo "IDE name parmeter (--ide) is required!"
    exit 1
fi

if [[ -z $IDE_VERSION ]]; then
    echo "IDE version parameter (--version) is required!"
    exit 1
fi

[[ -z $REGISTRY ]] && REGISTRY=$CONF_REGISTRY
[[ -z $IMAGE ]] && IMAGE=$CONF_IMAGE
[[ -z $USER_NAME ]] && USER_NAME=$CONF_USER_NAME
[[ -z $USER_PASSWORD ]] && USER_PASSWORD=$CONF_USER_PASSWORD

if [[ ${IDE_NAME,,} == 'intellij' || ${IDE_NAME,,} == 'idea' || ${IDE_NAME,,} == 'ultimate' ]]; then
    IDE_NAME=ideaIU
    IDE_ID=idea
elif [[ ${IDE_NAME,,} == 'webstorm' ]]; then
    IDE_NAME=WebStorm
    IDE_ID=webstorm
elif [[ ${IDE_NAME,,} == 'phpstorm' ]]; then
    IDE_NAME=PhpStorm
    IDE_ID=webide
elif [[ ${IDE_NAME,,} == 'datagrip' ]]; then
    IDE_NAME=datagrip
    IDE_ID=datagrip
fi

docker build -t $IMAGE --build-arg IDE_NAME=$IDE_NAME --build-arg IDE_ID=$IDE_ID --build-arg IDE_VERSION=$IDE_VERSION --build-arg USER_NAME=$USER_NAME --build-arg USER_PASSWORD=$USER_PASSWORD .
docker tag $IMAGE $IMAGE:${IDE_NAME,,}-$IDE_VERSION
docker tag $IMAGE $REGISTRY/$IMAGE:${IDE_NAME,,}-$IDE_VERSION
docker push $REGISTRY/$IMAGE:${IDE_NAME,,}-$IDE_VERSION
#docker rmi $REGISTRY/$IMAGE || true
#docker rmi $IMAGE || true