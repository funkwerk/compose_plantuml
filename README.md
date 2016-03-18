[![Build Status](https://travis-ci.org/funkwerk/compose_plantuml.svg)](https://travis-ci.org/funkwerk/compose_plantuml)
[![](https://badge.imagelayers.io/funkwerk/compose_plantuml.svg)](https://imagelayers.io/?images=funkwerk/compose_plantuml:latest 'funkwerk/compose_plantuml')
[![PyPi downloads](https://img.shields.io/pypi/dm/compose_plantuml.svg)](https://pypi.python.org/pypi/compose_plantuml/)
[![PyPi version](https://img.shields.io/pypi/v/compose_plantuml.svg)](https://pypi.python.org/pypi/compose_plantuml/)
[![Docker pulls](https://img.shields.io/docker/pulls/funkwerk/compose_plantuml.svg)](https://hub.docker.com/r/funkwerk/compose_plantuml/)

# compose_plantuml

Generate Plantuml graphs from docker-compose files

Currently just docker-compose version 2 is supported.

## Usage

### Via Python

Install it via:
`pip3 install compose_plantuml`

After that use it like:
`compose_plantuml docker-compose.yml`

### Via Docker

Use it like:
`cat docker-compose.yml | docker run -i funkwerk/compose_plantuml`

## Link Graph

Link Graphs provide an overview over docker-compose services.

Consider the following docker-compose.yml

```
version: '2'
services:
  first:
    links:
      - second
  second: {}
```

When calling 'compose_plantuml docker-compose.yml' it will generate the following link graph:

```
[first]
[second]
[first] --> [second]
```
