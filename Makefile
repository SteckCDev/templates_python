PYTHON_CMD = py
VENV_SCRIPTS_PATH = .venv/Scripts
VENV_ACTIVATION_CMD = $(VENV_SCRIPTS_PATH)/activate

venv:
	$(PYTHON_CMD) -m venv .venv
	$(VENV_ACTIVATION_CMD)
	python -m pip install -U pip poetry
	$(VENV_SCRIPTS_PATH)/poetry config virtualenvs.create false
	$(VENV_SCRIPTS_PATH)/poetry install
	$(VENV_SCRIPTS_PATH)/pre-commit install

env:
	cp src/.env.example src/.env

docker:
	docker compose --env-file src/.env up -d --build --force-recreate --remove-orphans --renew-anon-volumes

lint:
	poetry run ruff check --fix .

mypy:
	poetry run mypy src/

test:
	poetry run pytest .

build: venv env docker lint mypy test
