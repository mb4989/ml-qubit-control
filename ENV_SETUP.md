# Environment setup

## Python

Install Conda on your host. You can download the most recent release of Miniconda3:
```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```
For more details and a different release, visit Miniconda [download](https://docs.conda.io/en/latest/miniconda.html) and [installation](https://conda.io/projects/conda/en/stable/user-guide/install/index.html) pages.

Once Conda is installed, create the Python environment with the provided [configuration file](environment.yml):
```
conda env create -f environment.yml
```

Activate it:
```
conda activate ml-qubit-control-env
```
For more details about managing Conda environments see the [manual](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html).

## GPU Setup

The GPU setup may require some extra effort and the following instructions may not cover all of the corner cases.

If you have installed conda and create your environment `ml-qubit-control-env`, _likely_ TensorFlow and GPU libraries and drivers are correctly installed. You can test it, first run 
```
conda activate ml-qubit-control-env # if you don't have the environment active
ipython
```
then, in the `ipython` console:
```
import tensorflow as tf
tf.test.is_gpu_available()
```

If you get a message as
```
[...]
Could not load dynamic library 'libcusolver.so.10'; dlerror: libcusolver.so.10: cannot open shared object file: No such file or directory
[...]
```
You may try something like:
```
cd $HOME/miniconda3/envs/ml-qubit-control-env/lib
ln libcusolver.so.11 libcusolver.so.10
cd -
```
Then try again the GPU test.

## Julia

If Julia is not locally available and **you have root privileges**, you can install it via Snap, which usually points to a more recent version:
```
sudo snap install julia --classic
```
or you can download and install [julia-1.6.1.tgz](https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.1-linux-x86_64.tar.gz).

Either if you have installed Julia or had Julia already available on your host, add Jupyter Notebook and Juqbox packages to the Julia environment. Please notice that you **need to be in the environment `ml-qubit-control-env`**.
```
conda activate ml4qcontrol-env # if you don't have the environment active
julia -e 'using Pkg; Pkg.add("IJulia")'
julia -e 'using Pkg; Pkg.add(url="https://github.com/LLNL/Juqbox.jl.git"); Pkg.precompile(); Pkg.test("Juqbox")'
julia -e 'import Pkg; Pkg.add("JSON")'
julia -e 'import Pkg; Pkg.add("ArgParse")'
julia -e 'import Pkg; Pkg.add("NPZ")'
julia -e 'import Pkg; Pkg.add("Distributions")'
```

To remove it (but you may not need it):
```
conda remove --name ml-qubit-control-env --all
sudo snap remove --purge  julia
```

## Jupyter

If you are running these notebooks on a remote server without a display available:

```
conda activate ml-qubit-control-env # if you don't have the environment active
jupyter-lab --generate-config
jupyter-lab password
```

At this point, you can run (please try to use a **DIFFERENT PORT** than your colleagues):
```
# jupyter-lab --no-browser --ip 0.0.0.0 --port=<PORT>
jupyter-lab --no-browser --ip 0.0.0.0 --port=8081
```

You can access the notebook from your remote machine over SSH by setting up a SSH tunnel. Run the following command from your _local machine_:

```
# Replace <PORT> with the port number you selected in the above step
# Replace <REMOTE_USER> with the remote server username
# Replace <REMOTE_HOST> with your remote server address
#ssh -L 8888:localhost:<PORT> <REMOTE_USER>@<REMOTE_HOST>
ssh -L 8888:localhost:8081 <REMOTE_USER>@<REMOTE_HOST>
```

Then point your browser to `https://localhost:<PORT>`. Once again, point to the `PORT` you chose when running the previous command.

## Dependencies

_DEPRECATED_ but keep this here for the moment...

- Julia 1.6
  - ArgParse v1.1.4
  - NPZ v0.4.2
  - JSON v0.21.3
  - Juqbox v0.2.6
- Python 3.9
  - qutip == 4.7.0

