# Jupyter Notebook

To build the Docker image:
```
docker image build -t jupyter-notebook .
```

To run the Docker container:
```
docker run --rm -p 8888:8888 -v "$PWD":/home/jovyan -e JUPYTER_ENABLE_LAB="1" --name notebook jupyter-notebook start-notebook.sh --LabApp.token=''
```

To run the Docker container in background:
```
docker run -d -p 8888:8888 -v "$PWD":/home/jovyan -e JUPYTER_ENABLE_LAB="1" --name notebook jupyter-notebook start-notebook.sh --LabApp.token=''
```

To run a shell in the Docker container:
```
docker exec -i -t notebook /bin/bash
```

For more information take a look [here](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/running.html).
