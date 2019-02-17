# Jupyter Notebook

## Pull or Build image

To pull from Docker Hub:
```
docker pull feel/jupyter-docker
```

To build the Docker image:
```
docker image build -t notebook .
```

## Run/Stop container

To run the Docker container:
```
docker run --rm -p 8888:8888 -v "$PWD":/home/jovyan -e JUPYTER_ENABLE_LAB="1" --name notebook jupyter-notebook start-notebook.sh --LabApp.token=''
```

To run the Docker container in background:
```
docker run -d -p 8888:8888 -v "$PWD":/home/jovyan -e JUPYTER_ENABLE_LAB="1" --name notebook jupyter-notebook start-notebook.sh --LabApp.token=''
```

For more information take a look [here](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/running.html).

### Automtically start container

To start container automatically take a look [here](https://docs.docker.com/config/containers/start-containers-automatically/).

## Run shell in container

To run a shell in the Docker container:
```
docker exec -i -t notebook /bin/bash
```
