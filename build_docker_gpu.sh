#!/bin/bash
# Copyright (C) 2020 THL A29 Limited, a Tencent company.
# All rights reserved.
# Licensed under the BSD 3-Clause License (the "License"); you may
# not use this file except in compliance with the License. You may
# obtain a copy of the License at
# https://opensource.org/licenses/BSD-3-Clause
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied. See the License for the specific language governing
# permissions and limitations under the License.
# See the AUTHORS file for names of contributors.

cd $(dirname $0)/
set -xe
VERSION="0.0.1"

CUDA_VERSION=10.1
CUDNN_VERSION=7
PYTORCH_VERSION=1.7.0
TENSORFLOW_VERSION=2.5.0
BUILD_TYPES=("dev")

DEV_IMAGE=neofung/deep_learning_gpu:latest

for BUILD_TYPE in ${BUILD_TYPES[*]}
do
  if [ $BUILD_TYPE == "dev" ]; then
      NV_BASE_IMAGE=${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel-ubuntu18.04
  elif [ $BUILD_TYPE == "release" ]; then
      NV_BASE_IMAGE=${CUDA_VERSION}-base-ubuntu18.04
  fi

  sed 's#IMAGE_BASE#nvidia/cuda:'${NV_BASE_IMAGE}'#g' ./Dockerfile.gpu.template |
  sed 's#CUDA_VERSION#'${CUDA_VERSION}'#g'         |
  sed 's#CUDNN_VERSION#'${CUDNN_VERSION}'#g'         |
  sed 's#PYTORCH_VERSION#'${PYTORCH_VERSION}'#g'   |
  sed 's#TENSORFLOW_VERSION#'${TENSORFLOW_VERSION}'#g'   |
  sed 's#DEV_IMAGE#'${DEV_IMAGE}'#g'               > Dockerfile.gpu

  docker build ${EXTRA_ARGS} -t neofung/deep_learning_gpu_${BUILD_TYPE}:latest \
    -t neofung/deep_learning_gpu:${VERSION}-cuda${CUDA_VERSION}-cudnn${CUDNN_VERSION}-tf_${TENSORFLOW_VERSION}-torch_${PYTORCH_VERSION}-gpu-${BUILD_TYPE} -f Dockerfile.gpu  .

done
