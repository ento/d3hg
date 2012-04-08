NODE_PATH = ./node_modules
COFFEE_COMPILER = $(NODE_PATH)/coffee-script/bin/coffee
JS_COMPILER = $(NODE_PATH)/uglify-js/bin/uglifyjs
JS_TESTER = $(NODE_PATH)/vows/bin/vows

SRC = src/core.coffee \
	src/stencils.coffee
ICONS_SRC = src/raphael_icons.coffee
LIB = $(patsubst src/%.coffee,lib/%.js,$(SRC))
ICONS_LIB = $(patsubst src/%.coffee,lib/%.js,$(ICONS_SRC))

all: $(LIB) d3hg.js d3hg.min.js d3hg.icons.js d3hg.icons.min.js

lib/%.js: src/%.coffee
	$(COFFEE_COMPILER) --output lib --compile $<

d3hg.js: Makefile $(SRC)
	$(COFFEE_COMPILER) --join $@ --compile $(filter %.coffee,$^)

d3hg.min.js: d3hg.js Makefile
	@rm -f $@
	$(JS_COMPILER) < $< > $@

d3hg.icons.js: $(ICONS_SRC)
	@rm -f $@
	$(COFFEE_COMPILER) --join $@ --compile $(filter %.coffee,$^)

d3hg.icons.min.js: $(ICONS_LIB)
	@rm -f $@
	$(JS_COMPILER) < $< > $@

test: d3hg.js
	@./node_modules/mocha/bin/mocha test/*.coffee

.PHONY: test