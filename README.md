# README

This project contains a tiny patch and Dockerfile files.

It also has JAR file to build a container image, but I expected nobody use this JAR file directory.

# Re-generating JAR file

You can re-generate the jar file as follows.

## Prerequisites

* OpenJDK 11
* Maven

## Procedures

```
$ git clone --branch v7.10.0 --single-branch https://github.com/OpenAPITools/openapi-generator.git
$ ( cd  openapi-generator && cd patch -p1 < ../patch/20241130_my_ogc_v7.10.0.diff )
$ ( cd openapi-generator && mvn clean install )
$ cp openapi-generator/modules/openapi-generator-cli/target/openapi-generator-cli.jar .
```

