.PHONY: clean
clean:
	@rm -rf dist pyolice.egg-info
	@rm -rf .cover
	@rm -f .coverage

.PHONY: test
test:
	PYTHONPATH=. pytest $(filter-out $@,$(MAKECMDGOALS))

.PHONY: coverage
coverage: ## Generate a test coverage report based on `manage.py test`
	PYTHONPATH=. pytest . --cov=. --cov-report term-missing \
			   --cov-report html:.cover \
			   --cov-report xml:./coverage.xml \
			   --junitxml ./test-reports/xunit.xml

.PHONY: setup
setup:
	rm -rf .git/hooks && ln -s $(shell pwd)/git-hooks .git/hooks

.PHONY: publish  ## Publish a new version
publish: clean
	python setup.py sdist bdist_wheel
	twine upload dist/* --config-file .pypirc --skip-existing

.PHONY: generate-stubs
generate-stubs: clean
	find . -type f -name '*.pyi' | xargs rm
	stubgen pyolice/ -o .

.PHONY: lint  ## lint code
lint:
	black . --check
	mypy .
	isort -c

.PHONY: check-version-bump
check-version-bump:
	./check_version_bump.sh

help:  ## List all make targets
	@echo "Usage: make [TARGET] [-- ARGS...]\n"
	@echo "Available targets:"
	@awk -F ': [ [:alnum:]_\-]* +##' 'NF>1 {printf "\033[36m  %-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo


.DEFAULT_GOAL := help
