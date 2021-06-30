include Makefile.paths

PROJECT_DIRS=$(dir $(wildcard */Makefile))
VERSION_DATA_FILE=_data/version.yaml

.PHONY: all clean release release-clean $(PROJECT_DIRS) ${VERSION_DATA_FILE}

all: $(PROJECT_DIRS) _data/version.yaml

$(PROJECT_DIRS):
	$(MAKE) -C $@ all

$(VERSION_DATA_FILE):
	-@mkdir -p $(dir ${VERSION_DATA_FILE})
	echo "commit_hash: ${COMMIT_HASH}" > ${VERSION_DATA_FILE}

$(VERSION_DATA_FILE): COMMIT_HASH=$(shell git log -1 --pretty="format:%h")

clean: release-clean
	@for dir in $(PROJECT_DIRS); do \
		$(MAKE) -C $$dir clean; \
	done
	@rm -rf _data/

release: all
	jekyll build

release-clean:
	jekyll clean
