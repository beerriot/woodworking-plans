include Makefile.paths

TARGETS_HTML=$(shell ls *.html | sed -e "s,^,${RELEASE_DIR},g")

.PHONY: all clean release release-clean
all:
	@for dir in $(dir $(wildcard */Makefile)); do \
		$(MAKE) -C $$dir all; \
	done

${RELEASE_DIR}%.html: %.html
	-@mkdir -p ${RELEASE_DIR}
	tail +2 $< | sed -e '/{{body}}/r /dev/stdin' -e 's/{{body}}//' -e 's/{{subtitle}}/${TITLE}/' common/template.html > $@

${RELEASE_DIR}%.html: TITLE=$(shell head -1 $<)


clean: release-clean
	@for dir in $(dir $(wildcard */Makefile)); do \
		$(MAKE) -C $$dir clean; \
	done

release: all ${TARGETS_HTML}
	-@mkdir -p ${RELEASE_DIR}
	@for dir in $(dir $(wildcard */Makefile)); do \
		cp -R $${dir}${BUILD_DIR} ${RELEASE_DIR}$$dir; \
	done

release-clean:
	-@rm -r ${RELEASE_DIR}
