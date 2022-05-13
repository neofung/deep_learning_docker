# ZenDNN Dockerfile

## tree .

```shell
$ tree
.
├── aocc-compiler-3.2.0.tar
├── aocl-blis-linux-aocc-3.1.0.tar.gz
├── aocl-linux-aocc-3.1.0.tar.gz
├── build_conda_docker.sh
├── build_docker.sh
├── CONDA_ENV.conda.yaml
├── CONDA_ENV.cpu.yaml
├── conda_env_export.py
├── condarc
├── Dockerfile.conda.template
├── Dockerfile.cpu.template
├── PT_v1.9.0_ZenDNN_v3.2_Python_v3.7_2021-12-03T10
│   ├── LICENSE
│   ├── system_hw_os_kernel_bios_info.txt
│   ├── THIRD-PARTY-PROGRAMS
│   ├── torch-1.9.0a0+gitd69c22d-cp37-cp37m-linux_x86_64.whl
│   └── ZenDNN
│       ├── include -> ./include_LP64
│       ├── lib -> ./lib_LP64
│       ├── _out
│       │   └── lib
│       │       └── libamdZenDNN.so
│       ├── scripts
│       │   ├── gather_hw_os_kernel_bios_info.sh
│       │   ├── pt_cnn_benchmarks_latency.sh
│       │   ├── pt_cnn_benchmarks.py
│       │   ├── pt_cnn_benchmarks_throughput.sh
│       │   ├── PT_ZenDNN_setup_release.sh
│       │   ├── system_hw_os_kernel_bios_info.txt
│       │   └── zendnn_aocc_env_setup.sh
│       └── system_hw_os_kernel_bios_info.txt
├── README.md
└── superupdate.sh
```

## HOW TO USE

### 1. build conda env docker

```shell
$ ./build_conda_docker.sh 
+ VERSION=0.0.1
+ UBUNTU_VERSION=18.04
+ CONDA_VERSION=4.7.12.1
+ OS_TYPE=x86_64
+ PYTHON_VERSION=3.7.7
+ sed s#UBUNTU_VERSION#18.04#g ./Dockerfile.conda.template
+ sed s#CONDA_VERSION#4.7.12.1#g
+ sed s#OS_TYPE#x86_64#g
+ sed s#PYTHON_VERSION#3.7.7#g
+ docker build -t neofung/miniconda:latest -t neofung/miniconda:0.0.1-conda_4.7.12.1-py_3.7.7 -f Dockerfile.conda .
Sending build context to Docker daemon  372.3MB
Step 1/13 : FROM ubuntu:18.04
 ---> c6ad7e71ba7d
Step 2/13 : COPY ./superupdate.sh superupdate.sh
 ---> Using cache
 ---> 6af6a1180a50
Step 3/13 : RUN bash ./superupdate.sh cn && rm -rf /var/lib/apt/lists/*
 ---> Using cache
 ---> 5ed5696510fb
Step 4/13 : RUN apt-get --allow-releaseinfo-change update && apt-get install -yq cmake curl wget jq vim && rm -rf /var/lib/apt/lists/*
 ---> Using cache
 ---> 4b797ee2ded9
Step 5/13 : RUN curl -LO "http://repo.continuum.io/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh" &&     bash Miniconda3-4.7.12.1-Linux-x86_64.sh -p /opt/conda -b &&     rm Miniconda3-4.7.12.1-Linux-x86_64.sh
 ---> Using cache
 ---> e2903d6d7b75
Step 6/13 : RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /root/.bashrc &&     echo "conda activate base" >> /root/.bashrc
 ---> Using cache
 ---> 38866ac303c6
Step 7/13 : ENV PATH=/opt/conda/bin:${PATH}
 ---> Using cache
 ---> 6c64dd1d9ba3
Step 8/13 : COPY ./condarc /root/.condarc
 ---> Using cache
 ---> 2e9aba34215c
Step 9/13 : RUN    /opt/conda/bin/conda clean -i &&        /opt/conda/bin/conda config --set allow_conda_downgrades true &&        /opt/conda/bin/conda info
 ---> Using cache
 ---> be461a2f764b
Step 10/13 : RUN conda install -c anaconda -y python=3.7.7 &&     conda clean -yfa
 ---> Using cache
 ---> f3611c857b6a
Step 11/13 : RUN pip --no-cache-dir install pyyaml==6.0
 ---> Using cache
 ---> 58003b523358
Step 12/13 : SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]
 ---> Using cache
 ---> f7236982dd89
Step 13/13 : RUN /opt/conda/bin/conda env export --no-builds
 ---> Using cache
 ---> f07526614031
Successfully built f07526614031
Successfully tagged neofung/miniconda:latest
Successfully tagged neofung/miniconda:0.0.1-conda_4.7.12.1-py_3.7.7
```

### 2. Build ZenDNN docker

```shell
$ ./build_docker.sh 
+ VERSION=0.0.1
+ UBUNTU_VERSION=20.04
+ CONDA_VERSION=4.7.12.1
+ OS_TYPE=x86_64
+ PYTHON_VERSION=3.7.7
+ TENSORFLOW_VERSION=2.7.0
+ PYTORCH_VERSION=1.9.0
+ TORCHVISION_VERSION=0.10.0
+ sed s#UBUNTU_VERSION#20.04#g ./Dockerfile.cpu.template
+ sed s#CONDA_VERSION#4.7.12.1#g
+ sed s#OS_TYPE#x86_64#g
+ sed s#PYTHON_VERSION#3.7.7#g
+ sed s#TENSORFLOW_VERSION#2.7.0#g
+ sed s#PYTORCH_VERSION#1.9.0#g
+ sed s#TORCHVISION_VERSION#0.10.0#g
+ sed s#VERSION#0.0.1#g
+ docker build -t neofung/deep_learning_cpu:latest -t neofung/deep_learning_cpu:0.0.1-py_3.7.7-torch_zendnn_1.9.0 -f Dockerfile.cpu .
Sending build context to Docker daemon  372.3MB
Step 1/9 : FROM neofung/miniconda:0.0.1-conda_4.7.12.1-py_3.7.7
 ---> f07526614031
Step 2/9 : RUN /opt/conda/bin/conda install -c pytorch -y pytorch==1.9.0 torchvision==0.10.0 cpuonly &&     pip --no-cache-dir install future==0.18.2 numpy==1.20.2 &&     /opt/conda/bin/conda clean -yfa
 ---> Using cache
 ---> 994fc609305b
Step 3/9 : COPY aoc*.tar* /root/
 ---> Using cache
 ---> 8fc7a984efaf
Step 4/9 : RUN apt-get update && apt-get -y install sudo dmidecode hwloc && rm -rf /var/lib/apt/lists/*
 ---> Using cache
 ---> 6963e316f7f8
Step 5/9 : RUN cd /root/ &&     tar -xvf aocl-linux-aocc-3.1.0.tar.gz &&     cd aocl-linux-aocc-3.1.0 &&     tar -xvf /root/aocl-blis-linux-aocc-3.1.0.tar.gz &&     /bin/bash install.sh &&     echo "source /root/amd/aocl/3.1.0/amd-libs.cfg" >> /root/.bashrc &&     rm -rf /root/aocl*.tar*
 ---> Using cache
 ---> a9498df0c0c6
Step 6/9 : RUN cd /root/ &&     tar -xvf  aocc-compiler-3.2.0.tar &&     cd aocc-compiler-3.2.0 &&     /bin/bash install.sh &&     echo "source /root/setenv_AOCC.sh" >> /root/.bashrc &&     rm -rf /root/aocc-compiler-3.2.0.tar
 ---> Using cache
 ---> ad13c12edf28
Step 7/9 : ENV ZENDNN_BLIS_PATH=/root/amd/aocl/3.1.0 ZENDNN_AOCC_COMP_PATH=/root/aocc-compiler-3.2.0
 ---> Using cache
 ---> 0961f16d95a9
Step 8/9 : ENV LD_LIBRARY_PATH=/workspace/PT_v1.9.0_ZenDNN_v3.2_Python_v3.7_2021-12-03T10/ZenDNN/_out/lib/:/workspace/PT_v1.9.0_ZenDNN_v3.2_Python_v3.7_2021-12-03T10/ZenDNN/external/googletest/lib:/root/amd/aocl/3.1.0/lib/:/root/aocc-compiler-3.2.0/lib:/root/aocc-compiler-3.2.0/lib32
 ---> Using cache
 ---> 831b035fc772
Step 9/9 : SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]
 ---> Using cache
 ---> 772273cf3eb1
Successfully built 772273cf3eb1
Successfully tagged neofung/deep_learning_cpu:latest
Successfully tagged neofung/deep_learning_cpu:0.0.1-py_3.7.7-torch_zendnn_1.9.0
```

### Execute the docker image

```shell
docker run -it --rm --name=zendnn -v $PWD:/workspace neofung/deep_learning_cpu:0.0.1-py_3.7.7-torch_zendnn_1.9.0 /bin/bash
```

In container __zendnn__ , compare the original pytorch and zendnn optimized
```shell
(base) root@02eff2182b98:/# cd /workspace/PT_v1.9.0_ZenDNN_v3.2_Python_v3.7_2021-12-03T10/ZenDNN/scripts/
(base) root@02eff2182b98:/workspace/PT_v1.9.0_ZenDNN_v3.2_Python_v3.7_2021-12-03T10/ZenDNN/scripts# 
(base) root@02eff2182b98:/workspace/PT_v1.9.0_ZenDNN_v3.2_Python_v3.7_2021-12-03T10/ZenDNN/scripts# python pt_cnn_benchmarks.py 
Downloading: "https://download.pytorch.org/models/resnet50-0676ba61.pth" to /root/.cache/torch/hub/checkpoints/resnet50-0676ba61.pth
100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 97.8M/97.8M [00:01<00:00, 74.5MB/s]
********************************************************************************
*                                 resnet50_bs1                                 *
********************************************************************************
resnet50_bs1:                    Warm up time:   0.043s       QPS:   23.16
resnet50_bs1:                  Inference time:   0.029s       QPS:   34.51
(base) root@02eff2182b98:/workspace/PT_v1.9.0_ZenDNN_v3.2_Python_v3.7_2021-12-03T10/ZenDNN/scripts# 
(base) root@02eff2182b98:/workspace/PT_v1.9.0_ZenDNN_v3.2_Python_v3.7_2021-12-03T10/ZenDNN/scripts# pip install /workspace/PT_v1.9.0_ZenDNN_v3.2_Python_v3.7_2021-12-03T10/torch-1.9.0a0+gitd69c22d-cp37-cp37m-linux_x86_64.whl 
Processing /workspace/PT_v1.9.0_ZenDNN_v3.2_Python_v3.7_2021-12-03T10/torch-1.9.0a0+gitd69c22d-cp37-cp37m-linux_x86_64.whl
Requirement already satisfied: typing-extensions in /opt/conda/lib/python3.7/site-packages (from torch==1.9.0a0+gitd69c22d) (4.1.1)
Installing collected packages: torch
  Found existing installation: torch 1.9.0
    Uninstalling torch-1.9.0:
      Successfully uninstalled torch-1.9.0
Successfully installed torch-1.9.0a0+gitd69c22d
(base) root@02eff2182b98:/workspace/PT_v1.9.0_ZenDNN_v3.2_Python_v3.7_2021-12-03T10/ZenDNN/scripts# 
(base) root@02eff2182b98:/workspace/PT_v1.9.0_ZenDNN_v3.2_Python_v3.7_2021-12-03T10/ZenDNN/scripts# python pt_cnn_benchmarks.py ********************************************************************************
*                                 resnet50_bs1                                 *
********************************************************************************
resnet50_bs1:                    Warm up time:   0.054s       QPS:   18.64
resnet50_bs1:                  Inference time:   0.036s       QPS:   27.58
(base) root@02eff2182b98:/workspace/PT_v1.9.0_ZenDNN_v3.2_Python_v3.7_2021-12-03T10/ZenDNN/scripts# 
```


