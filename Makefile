
WORK_DIR ?= $(PWD)
DOCKER_IMAGE ?= feel/ganimede


###########################
# General targets
###########################
test:
	docker exec -it ganimede /bin/bash -c 'papermill work/tests/test_notebook.ipynb /tmp/test_notebook_output.ipynb'


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

docker-run-base:
	docker run -p 8888:8888 \
        $(DOCKER_ARGS) \
        -v "$(WORK_DIR)":/home/jovyan/work \
        -e JUPYTER_ENABLE_LAB="1" \
        --name ganimede $(DOCKER_IMAGE) start-notebook.sh --LabApp.token=''

docker-run: DOCKER_ARGS += --rm
docker-run: docker-run-base

docker-background-run: DOCKER_ARGS += -d
docker-background-run: docker-run

docker-boot-run: DOCKER_ARGS += -d --restart unless-stopped
docker-boot-run: docker-run-base

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


