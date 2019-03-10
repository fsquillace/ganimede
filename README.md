# Jupyter Notebook

## Manage Docker images

To pull from Docker Hub:
```
docker pull feel/jupyter-docker
```

To update the parent image too:
```
docker pull jupyter/all-spark-notebook
```

To build the Docker image:
```
docker image build -t notebook .
```

To remove an old image:
```
# Get list of all existing images
docker images
# To clean up disk with old images
docker image rm <name-image>
```

## Manage Docker containers

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

To run the Docker container:
```
docker run --rm -p 8888:8888 -v "$PWD":/home/jovyan -e JUPYTER_ENABLE_LAB="1" --name notebook feel/jupyter-docker start-notebook.sh --LabApp.token=''
```

To run the Docker container in background:
```
docker run --rm -d -p 8888:8888 -v "$PWD":/home/jovyan -e JUPYTER_ENABLE_LAB="1" --name notebook feel/jupyter-docker start-notebook.sh --LabApp.token=''
```

For more information take a look [here](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/running.html).

### Automatically start container

```
docker run -d --restart unless-stopped -p 8888:8888 -v "$PWD":/home/jovyan -e JUPYTER_ENABLE_LAB="1" --name notebook feel/jupyter-docker start-notebook.sh --LabApp.token=''
```

For more information take a look [here](https://docs.docker.com/config/containers/start-containers-automatically/).

## Restart docker via systemd

```
sudo systemctl restart docker
```

## Run shell in container

To run a shell in the Docker container:
```
docker exec -i -t notebook /bin/bash
```

## Clean up unused containers, networks, volumes and images

```
docker system prune --all --volumes
```
