FROM docker.io/openapitools/openapi-generator-cli:v7.11.0

COPY openapi-generator-cli.jar /opt/openapi-generator/modules/openapi-generator-cli/target/openapi-generator-cli.jar

WORKDIR /local
