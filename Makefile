include Makefile.paths

.PHONY: all clean release release-clean
all:
	@for dir in $(dir $(wildcard */Makefile)); do \
		$(MAKE) -C $$dir all; \
	done

clean: release-clean
	@for dir in $(dir $(wildcard */Makefile)); do \
		$(MAKE) -C $$dir clean; \
	done

release: all
	-@mkdir -p ${RELEASE_DIR}
	@for dir in $(dir $(wildcard */Makefile)); do \
		cp -R $${dir}${BUILD_DIR} ${RELEASE_DIR}$$dir; \
	done

release-clean:
	-@rm -r ${RELEASE_DIR}
