
WORK_DIR ?= $(PWD)
DOCKER_IMAGE ?= feel/ganimede


###########################
# Docker related targets
###########################
# `--pull` attempts to pull latest version of base image:
docker-build:
	docker image build --pull -t ganimede -f Dockerfile .

docker-push:
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin
	docker push feel/ganimede

docker-pull:
	docker pull $(DOCKER_IMAGE)

docker-run:
	docker run --rm -p 8888:8888 \
        -v "$(WORK_DIR)":/home/jovyan/work \
        -e JUPYTER_ENABLE_LAB="1" \
        --name ganimede $(DOCKER_IMAGE) start-notebook.sh --LabApp.token=''

docker-background-run:
	docker run --rm -p 8888:8888 \
        -d \
        -v "$(WORK_DIR)":/home/jovyan/work \
        -e JUPYTER_ENABLE_LAB="1" \
        --name ganimede $(DOCKER_IMAGE) start-notebook.sh --LabApp.token=''

docker-boot-run:
	docker run -d --restart unless-stopped -p 8888:8888 \
        -v "$(WORK_DIR)":/home/jovyan/work \
        -e JUPYTER_ENABLE_LAB="1" \
        name notebook $(DOCKER_IMAGE) start-notebook.sh --LabApp.token=''

docker-shell:
	docker exec -it ganimede /bin/bash


###########################
# Systemd related targets
###########################
setup-systemd-service:
	mkdir -p ${HOME}/.config/systemd/user/
	cp ganimede.service ${HOME}/.config/systemd/user/
	systemctl --user daemon-reload
	systemctl --user enable ganimede.service

start-systemd-service: setup-systemd-service
	systemctl --user start ganimede.service


