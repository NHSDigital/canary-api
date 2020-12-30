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
	cp -R e2e/. dist/e2e
	cp -Rv proxies/live/apiproxy dist/proxies/live
	mkdir -p dist/proxies/live
	for env in internal-dev internal-dev-sandbox internal-qa internal-qa-sandbo ref sandbox int; do  # prod too when ecs can be deployed there
		cp ecs-proxies-deploy.yml dist/ecs-deploy-${env}.yml
	done;

check-licenses:
	@echo "Not configured"

lint:
	@echo "Not configured"

publish: clean
	mkdir -p build
	npm run publish

build-proxy:
	scripts/build_proxy.sh
