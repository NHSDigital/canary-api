SHELL=/bin/bash -euo pipefail

install: install-node install-python install-hooks

install-python:
	poetry install

install-node:
	npm install
	cd sandbox && npm install

install-hooks:
	cp scripts/pre-commit .git/hooks/pre-commit

test:
	@echo "No tests configured."

clean:
	rm -rf dist

release: clean publish
	mkdir -p dist
	cp build/canary-api.json dist
	mkdir -p dist/proxies/live
	cp -Rv proxies/live/apiproxy dist/proxies/live
	cp ecs-proxies-deploy.yml dist/ecs-deploy-internal-dev.yml

check-licenses:
	@echo "Not configured"

lint:
	@echo "Not configured"

publish: clean
	mkdir -p build
	npm run publish

build-proxy:
	scripts/build_proxy.sh
