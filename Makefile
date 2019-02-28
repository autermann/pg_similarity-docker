#!make

BUILD       := ./.build/docker-build
BUILD_URL   := "https://raw.githubusercontent.com/autermann/docker-build/master/docker-build"
REPOSITORY  := library/pgsimilarity
REGISTRY    := docker.52north.org
PGSIMILARITY_REPOSITORY := eulerto/pg_similarity
VERSION_LEVEL := minor
BUILD_FLAGS   += --license "GPLv2" --pull --no-branch --no-commit --repository $(REPOSITORY)
BUILD_FLAGS   += --url https://github.com/$(PGSIMILARITY_REPOSITORY) --version-level $(VERSION_LEVEL)
BUILD_FLAGS   += -b PGSIMILARITY_REPOSITORY=$(PGSIMILARITY_REPOSITORY) -b PGSIMILARITY_VERSION=master
DOCKER        := $(shell which docker)

.PHONY: clean latest all pg9.3 pg9.4 pg9.5 pg9.6 pg10 pg11
all: pg9.3 pg9.4 pg9.5 pg9.6 pg10 pg11

$(BUILD):
	@mkdir -p .build
	@curl -sLf $(BUILD_URL) -o $(BUILD)
	@chmod +x $(BUILD)

clean:
	@rm -rf .build
	-@$(DOCKER) rmi $$($(DOCKER) images $(REGISTRY)/$(REPOSITORY) --format '{{.Repository}}:{{.Tag}}') 2>/dev/null

latest: pg11

pg9.3 pg9.4 pg9.5 pg9.6 pg10 pg11: pg%: $(BUILD)
	$(BUILD) $(BUILD_FLAGS) -b POSTGRES_VERSION=$* --version $* .

pg11: BUILD_FLAGS += --latest
pg11 pg10: VERSION_LEVEL := major
