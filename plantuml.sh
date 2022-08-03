#!/usr/bin/env bash

set -o errexit
set -o pipefail

java -Djava.awt.headless=true -jar "/opt/plantuml.jar" "$@"
