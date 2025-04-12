#!/bin/bash

git rev-parse --abbrev-ref HEAD | awk -F'/' '{print $NF}' | sha256sum | awk '{print $1}'
