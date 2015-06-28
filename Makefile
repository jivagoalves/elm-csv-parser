wildc_recursive=$(foreach d,$(wildcard $1*),$(call wildc_recursive,$d/,$2) $(filter $(subst *,%,$2),$d))

ELM_SRC_FILES  = $(call wildc_recursive, src/, *.elm)
ELM_SPEC_FILES = $(call wildc_recursive, spec/, *.elm)
DIRS           = $(sort $(dir $(call wildc_recursive, src/, *)))

all: elm.js

elm.js: $(ELM_SRC_FILES)
	elm-make $(ELM_SRC_FILES) --yes --output $@

spec.js: $(ELM_SRC_FILES) $(ELM_SPEC_FILES)
	elm-make $(ELM_SRC_FILES) $(ELM_SPEC_FILES) --yes --output $@

spec.io.js: spec.js
	bin/elm-io.sh spec.js $@ MainSpec

spec: spec.io.js
	node spec.io.js

test: spec

cleanspec:
	rm -rf spec.*

clean:
	rm -rf elm.js elm-stuff spec.*

watch:
	@while true; do make | grep -v "^make\[1\]:"; sleep 2; done

.PHONY: all elm.js clean watch
