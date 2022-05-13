cd $(dirname $0)/
set -xe
VERSION=0.0.1

UBUNTU_VERSION=20.04
CONDA_VERSION=4.7.12.1
OS_TYPE=x86_64
PYTHON_VERSION=3.7.7
TENSORFLOW_VERSION=2.7.0
PYTORCH_VERSION=1.9.0
TORCHVISION_VERSION=0.10.0

sed 's#UBUNTU_VERSION#'${UBUNTU_VERSION}'#g' ./Dockerfile.cpu.template |
sed 's#CONDA_VERSION#'${CONDA_VERSION}'#g'	|
sed 's#OS_TYPE#'${OS_TYPE}'#g'			|
sed 's#PYTHON_VERSION#'${PYTHON_VERSION}'#g'   	|
sed 's#TENSORFLOW_VERSION#'${TENSORFLOW_VERSION}'#g'   |
sed 's#PYTORCH_VERSION#'${PYTORCH_VERSION}'#g'   |
sed 's#TORCHVISION_VERSION#'${TORCHVISION_VERSION}'#g'   |
sed 's#VERSION#'${VERSION}'#g'	> Dockerfile.cpu

docker build ${EXTRA_ARGS} -t neofung/deep_learning_cpu:latest \
    -t neofung/deep_learning_cpu:${VERSION}-py_${PYTHON_VERSION}-torch_zendnn_${PYTORCH_VERSION} -f Dockerfile.cpu  .
