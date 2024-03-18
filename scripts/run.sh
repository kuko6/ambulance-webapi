#!/bin/bash

command=$1

if [ -z "$command" ]; then
    command="start"
fi

project_root="$(dirname "$(readlink -f "$0")")/.."

export AMBULANCE_API_ENVIRONMENT="Development"
export AMBULANCE_API_PORT="8080"
export AMBULANCE_API_MONGODB_USERNAME="root"
export AMBULANCE_API_MONGODB_PASSWORD="neUhaDnes"

mongo() {
    docker-compose --file "${project_root}/deployments/docker-compose/compose.yaml" "$@"
}

case "$command" in
    "openapi")
        docker run --rm -ti -v ${project_root}:/local openapitools/openapi-generator-cli generate -c /local/scripts/generator-cfg.yaml
        ;;
    "start")
        trap 'mongo down' EXIT
        mongo up --detach
        go run ${project_root}/cmd/ambulance-api-service
        ;;
    "mongo")
        mongo up
        ;;
    "test")
        go test ./...
        ;;
    "docker")
        docker build -t kuko6/ambulance-wl-webapi:local-build -f ${project_root}/build/docker/Dockerfile .
        ;;
    *)
        echo "Unknown command: $command" >&2
        exit 1
        ;;
esac