APP_NAME=jupyter-lab
PORT=8888



# Build the container
.PHONY: build
build: ## Build the container
	echo 'Building docker image'
	docker build -t $(APP_NAME) .

lab: build
	docker run -i -t --rm -p=$(PORT):$(PORT) -v ${PWD}:/home/jovyan --name="$(APP_NAME)" $(APP_NAME) start.sh jupyter lab

stop: ## Stop and remove a running container
	docker stop $(APP_NAME)

sh:
	docker exec -it $(APP_NAME) bash

freeze:
	docker exec -it $(APP_NAME) pip freeze > requirements.txt
