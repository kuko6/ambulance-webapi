#!/bin/bash

command=$1

if [ -z "$command" ]; then
    command="start"
fi

project_root="$(dirname "$(readlink -f "$0")")/.."

export AMBULANCE_API_ENVIRONMENT="Development"
export AMBULANCE_API_PORT="8080"

case "$command" in
    "start")
        go run "${project_root}/cmd/ambulance-api-service"
        ;;
    "openapi")
        docker run --rm -ti -v "${project_root}":/local openapitools/openapi-generator-cli generate -c /local/scripts/generator-cfg.yaml
        ;;
    *)
        echo "Unknown command: $command"
        exit 1
        ;;
esac
