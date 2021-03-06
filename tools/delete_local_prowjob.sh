#!/usr/bin/env bash

#
# Copyright (C) 2020 The Falco Authors.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit

# desired cluster name; default is "kind"
KIND_CLUSTER_NAME="mkpod"

kind_network='bridge'
reg_name='kind-registry'
reg_port='5000'

# create registry container unless it already exists
running="$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)"
if [ "${running}" == 'true' ]; then
  cid="$(docker inspect -f '{{.ID}}' "${reg_name}")"
  echo "> Stopping and deleting Kind Registry container..."
  docker stop $cid >/dev/null
  docker rm $cid >/dev/null
fi

echo "> Deleting Kind cluster..."
kind delete cluster --name=$KIND_CLUSTER_NAME 
