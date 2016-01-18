#!/bin/bash

eval $(/usr/local/bin/userdata)
if [ "$CLOUD_ENVIRONMENT" = "ms-pro" ] ||  [ "$CLOUD_ENVIRONMENT" = "ms-pre" ]; then
  service datadog-agent start
fi
