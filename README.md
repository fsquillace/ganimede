# Ganimede Jupyter Notebook

## Quickstart

To run the Ganimede docker container:

```
make docker-run
```

Go to `http://localhost:8888` to access to the JupyterLab.

It is also possible to have the similar experience using conda environment instead
of a docker container. For more details look at the
[section](#manage-conda-environments) below.

## List of available packages/tools

The docker image is build on top of
[all-spark-notebook](https://github.com/jupyter/docker-stacks) image.
The following are the package/tools provided by Ganimede apart from the ones already
available in `all-spark-notebok`.

### Jupyter tools

- [Almond]*(https://almond.sh/)
- [DrawIO](https://github.com/QuantStack/jupyterlab-drawio)
- [IPySheet](https://github.com/QuantStack/ipysheet)
- [JupyText](https://github.com/mwouts/jupytext)
- [Jupyter Contrib extensions](https://github.com/ipython-contrib/jupyter_contrib_nbextensions)
- [Jupyter Vim binding](https://github.com/lambdalisue/jupyter-vim-binding)
- [JupyterLab Git](https://github.com/jupyterlab/jupyterlab-git)
- [JupyterLab Github](https://github.com/jupyterlab/jupyterlab-github)
- [JupyterLab TOC](https://github.com/jupyterlab/jupyterlab-toc)
- [JupyterLab Vim](https://github.com/jwkvam/jupyterlab-vim)
- [Livy](https://livy.apache.org/)
- [Papermill](https://github.com/nteract/papermill)
- [Qgrid](https://github.com/quantopian/qgrid)
- [S3Contents](https://github.com/danielfrg/s3contents)
- [SparkMagic](https://github.com/jupyter-incubator/sparkmagic)
- [Voila](https://github.com/voila-dashboards/voila)

### Libraries available

- TODO

## Manage Docker images

To pull Ganimede from Docker Hub:
```
make docker-pull
```

To build the Ganimede Docker image:
```
make docker-build
```

To remove an old image:

```
# Get list of all existing images
docker images
# To clean up disk with old images
docker image rm <name-image>
```

## Manage Docker containers

### Basic commands
To see all containers (even the ones no longer running):
```
docker ps -a
```

To kill a running container (for gracefully stop use `stop` command instead):
```
docker kill <container-id>
```

To remove old containers (use `--rm` when using `run` command to avoid this annoying step):
```
docker rm <container-id>
```

### Start container

To run the Docker container:
```
make docker-run WORK_DIR="/path/to/workdir"
```

To run the Docker container in background:
```
make docker-background-run WORK_DIR="/path/to/workdir"
```

For more information take a look [here](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/running.html).

To automatically start container at boot time:
```
make docker-boot-run WORK_DIR="/path/to/workdir"
```

#### Persist Jupyter user settings

The folder `.jupyter` contains the jupyter settings.
Add the following mount when running the container, considering your settings
are located in `/home/username/jupyter-config`:
```
     -v /home/username/jupyter-config/bash_history:/home/jovyan/.bash_history \
     -v /home/username/jupyter-config/jupyter:/home/jovyan/.jupyter
```

#### Using systemd (recommended)

If your system supports systemd you can run Ganimede as a Systemd service

```
make start-systemd-service
```


For more information take a look [here](https://docs.docker.com/config/containers/start-containers-automatically/).

## Restart docker via systemd

```
sudo systemctl restart docker
```

## Run shell in container

To run a shell in the Docker container:
```
make docker-shell
```

## Clean up unused containers, networks, volumes and images

```
docker system prune --all --volumes
```

## Manage Conda environments

There are scenarios where the Jupyter tools and the python libraries are in
different conda environments. You can use the scripts in `bin/` directory to
setup specific set of packages depending on the environment.

For example to setup the Ganimede tools in the conda environment
`jupyter-server` and setup python libraries to `myenv`:

```
make -f Makefile-conda conda-setup-tools CONDA_ENV=jupyter-server
make -f Makefile-conda conda-setup-libraries CONDA_ENV=myenv
```

