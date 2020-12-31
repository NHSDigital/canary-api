SHELL=/bin/bash -euo pipefail

install: install-node install-python install-hooks

install-python:
	poetry install

install-node:
	npm install

install-hooks:
	cp scripts/pre-commit .git/hooks/pre-commit

test:
	@echo "No tests configured."

clean:
	rm -rf dist

release: clean publish
	mkdir -p dist
	cp build/canary-api.json dist
	cp -R e2e dist
	mkdir -p dist/proxies/live
	cp -Rv proxies/live/apiproxy dist/proxies/live

	# can replace with `cp ecs-proxies-deploy.yml dist/ecs-deploy-all.yml` when prod is available
	for env in internal-dev internal-dev-sandbox internal-qa internal-qa-sandbox ref sandbox int; do \
   		cp ecs-proxies-deploy.yml dist/ecs-deploy-$$env.yml; \
	done

check-licenses:
	@echo "Not configured"

lint:
	@echo "Not configured"

publish: clean
	mkdir -p build
	npm run publish

build-proxy:
	rm -rf build/proxies;
	mkdir -p build/proxies/live;
	cp -Rv proxies/live/apiproxy build/proxies/live
