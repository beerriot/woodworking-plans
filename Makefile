include Makefile.paths

TARGETS_HTML=$(shell ls *.html | sed -e "s,^,${RELEASE_DIR},g")
PROJECT_DIRS=$(dir $(wildcard */Makefile))

.PHONY: all clean release release-clean $(PROJECT_DIRS)

all: $(PROJECT_DIRS)

$(PROJECT_DIRS):
	$(MAKE) -C $@ all

${RELEASE_DIR}%.html: %.html common/template.html
	-@mkdir -p ${RELEASE_DIR}
	tail +2 $< | sed -e '/{{body}}/r /dev/stdin' -e 's/{{body}}//' -e 's/{{subtitle}}/${TITLE}/' common/template.html > $@

${RELEASE_DIR}%.html: TITLE=$(shell head -1 $<)


clean: release-clean
	@for dir in $(PROJECT_DIRS); do \
		$(MAKE) -C $$dir clean; \
	done

release: all ${TARGETS_HTML}
	-@mkdir -p ${RELEASE_DIR}
	@for dir in $(dir $(wildcard */Makefile)); do \
		cp -R $${dir}${BUILD_DIR} ${RELEASE_DIR}$$dir; \
	done
	@cp -R site ${RELEASE_DIR}

release-clean:
	-@rm -r ${RELEASE_DIR}
