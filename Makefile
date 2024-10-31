PYTHON_CMD = python3.12
SRC_DIR = src
VENV_DIR = .venv
VENV_SCRIPTS_PATH = ${VENV_DIR}/bin

venv:
	$(PYTHON_CMD) -m venv ${VENV_DIR}
	${VENV_SCRIPTS_PATH}/python -m pip install -U pip poetry
	$(VENV_SCRIPTS_PATH)/poetry config virtualenvs.create false
	$(VENV_SCRIPTS_PATH)/poetry install --no-root
	$(VENV_SCRIPTS_PATH)/pre-commit install

env:
	cp ${SRC_DIR}/.env.example ${SRC_DIR}/.env

docker:
	docker compose --env-file ${SRC_DIR}/.env up -d --build --force-recreate --remove-orphans --renew-anon-volumes

lint:
	${VENV_SCRIPTS_PATH}/poetry run ruff check --fix .

mypy:
	${VENV_SCRIPTS_PATH}/poetry run mypy ${SRC_DIR}

test:
	${VENV_SCRIPTS_PATH}/poetry run pytest .

build: venv lint mypy env docker test
