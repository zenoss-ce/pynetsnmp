#
# Makefile for pynetsnmp
#
VERSION = 0.40.7

# Define the image name, version and tag name for the docker build image
BUILD_IMAGE = build-tools
BUILD_VERSION = 0.0.10
TAG = zenoss/$(BUILD_IMAGE):$(BUILD_VERSION)

UID := $(shell id -u)
GID := $(shell id -g)

DOCKER_RUN := echo "=== With docker $(TAG) ==="; docker run --rm \
		-v $(PWD):/mnt \
		--user $(UID):$(GID) \
		$(TAG) \
		/bin/bash -c

IN_DOCKER = 1

build-bdist:
	@echo "Building a binary distribution of pynetsnmp"
	if [ -n "$(IN_DOCKER)" ]; then \
		$(DOCKER_RUN) "cd /mnt && python setup.py bdist_wheel"; \
	else \
		python setup.py bdist_wheel; \
	fi

build-sdist:
	@echo "Building a source distribution of pynetsnmp"
	if [ -n "$(IN_DOCKER)" ]; then \
		$(DOCKER_RUN) "cd /mnt && python setup.py sdist"; \
	else \
		python setup.py sdist; \
	fi

# Default to building a binary distribution
build: build-bdist

clean:
	rm -rf *.pyc MANIFEST dist build pynetsnmp.egg-info
