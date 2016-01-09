#!/usr/bin/env bash
git describe --tags --long --dirty --always > version
docker build -t $1 .
