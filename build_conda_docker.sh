cd $(dirname $0)/
set -xe
VERSION=0.0.1

UBUNTU_VERSION=20.04
CONDA_VERSION=4.7.12.1
OS_TYPE=x86_64
PYTHON_VERSION=3.7.7

sed 's#UBUNTU_VERSION#'${UBUNTU_VERSION}'#g' ./Dockerfile.conda.template |
sed 's#CONDA_VERSION#'${CONDA_VERSION}'#g'	|
sed 's#OS_TYPE#'${OS_TYPE}'#g'			|
sed 's#PYTHON_VERSION#'${PYTHON_VERSION}'#g'   	> Dockerfile.conda

docker build ${EXTRA_ARGS} -t neofung/miniconda:latest \
    -t neofung/miniconda:${VERSION}-conda_${CONDA_VERSION}-py_${PYTHON_VERSION} -f Dockerfile.conda  .
