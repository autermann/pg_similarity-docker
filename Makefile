#!make

PGSIMILARITY_REPOSITORY := eulerto/pg_similarity
BUILD       := ./.build/docker-build
BUILD_URL   := "https://raw.githubusercontent.com/autermann/docker-build/master/docker-build"
BUILD_FLAGS += --url "https://www.rstudio.org"
BUILD_FLAGS += --license "GPLv2"
BUILD_FLAGS += --repository "library/pgsimilarity"
BUILD_FLAGS += --url https://github.com/$(PGSIMILARITY_REPOSITORY)
BUILD_FLAGS += --pull
BUILD_FLAGS += -b PGSIMILARITY_REPOSITORY=$(PGSIMILARITY_REPOSITORY)
BUILD_FLAGS += -b PGSIMILARITY_VERSION=master

.PHONY: all
all: pg9.2 pg9.3 pg9.4 pg9.5 pg9.6 pg10 pg11

$(BUILD):
	@mkdir -p .build
	@curl -sLf $(BUILD_URL) -o $(BUILD)
	@chmod +x $(BUILD)

.PHONY: clean
clean:
	@rm -rf .build

.PHONY: pg9.2 pg9.3 pg9.4 pg9.5 pg9.6 pg10 pg11
pg9.2 pg9.3 pg9.4 pg9.5 pg9.6 pg10 pg11: $(BUILD)
pg9.2 pg9.3 pg9.4 pg9.5 pg9.6 pg10 pg11: pg%:
	$(BUILD) $(BUILD_FLAGS) -b POSTGRES_VERSION=$* --version $* .

