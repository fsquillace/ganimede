# Ganimede Jupyter Notebook

## Manage Conda environments

### Use environment lock file

The file `environment-lock.yml` contains all conda/pip dependencies generated
by a stable version of the Ganimede Docker image.
This can be considered the most stable way to install all tools/library from
Ganimede when using Conda environments.
The disadvantage is that the packages will not be the most updated
versions.

To create a Conda environment (default is `base`) from the lock file:
```
make conda-create-from-lock-file CONDA_ENV=myenv
```

To update a Conda environment (default is `base`) from the lock file:
```
make conda-update-from-lock-file CONDA_ENV=myenv
```

To update a Conda environment (default is `base`) from the lock file but prune
the package not belonging to the lock file:
```
make update-prune-from-lock-file CONDA_ENV=myenv
```

### Use the setup tools/library scripts
There are scenarios where the Jupyter server/tools and the python libraries are in
different conda environments. You can use the scripts in `bin/` directory to
setup specific set of packages depending on the environment.

For example to setup the Ganimede tools in the conda environment
`jupyter-server` and setup python libraries to `myenv`:

```
make conda-setup-tools CONDA_ENV=jupyter-server
make conda-setup-libraries CONDA_ENV=myenv
```

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
