SHELL=/bin/bash -euo pipefail

install:
	poetry install
	cd docker && npm install

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
	npm run publish 2> /dev/null
