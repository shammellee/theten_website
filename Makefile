.PHONY: all clean $(DEV_DEPS) $(PROD_DEPS) test

# CONFIG
SHELL    := /bin/bash
MAKEFLAGS = -j 3  # limit parallel recipe execution

# COLORS
COLORS.RED     := \033[31m
COLORS.GREEN   := \033[32m
COLORS.YELLOW  := \033[33m
COLORS.BLUE    := \033[34m
COLORS.MAGENTA := \033[35m
COLORS.CYAN    := \033[36m
COLORS.NORMAL  := \033[0m

# PATHS
SRC.DIR            := src
BUILD.DIR          := public
SUPPORT.DIR        := support

SRC.COFFEE_DIR      = $(SRC.DIR)/coffee
SRC.FONT_DIR        = $(SRC.DIR)/fonts
SRC.IMG_DIR         = $(SRC.DIR)/img
SRC.JADE_DIR        = $(SRC.DIR)/jade
SRC.JADE_INC_DIR    = $(SRC.JADE_DIR)/inc
SRC.STYLUS_DIR      = $(SRC.DIR)/styl
SRC.STYLUS_INC_DIR  = $(SRC.STYLUS_DIR)/inc
SRC.VENDOR_DIR      = $(SRC.DIR)/vendor

BUILD.CSS_NAME     := css
BUILD.FONT_NAME    := fonts
BUILD.IMG_NAME     := img
BUILD.JS_NAME      := js
BUILD.CSS_DIR       = $(BUILD.DIR)/$(BUILD.CSS_NAME)
BUILD.FONT_DIR      = $(BUILD.DIR)/$(BUILD.FONT_NAME)
BUILD.IMG_DIR       = $(BUILD.DIR)/$(BUILD.IMG_NAME)
BUILD.JS_DIR        = $(BUILD.DIR)/$(BUILD.JS_NAME)
BUILD.DIRS          = $(BUILD.DIR)
BUILD.DIRS         += $(BUILD.CSS_DIR)
BUILD.DIRS         += $(BUILD.FONT_DIR)
BUILD.DIRS         += $(BUILD.IMG_DIR)
BUILD.DIRS         += $(BUILD.JS_DIR)

# DEPENDENCIES
DEV_DEPS := dev.dirs dev.setup dev.coffee dev.jade dev.styl
PROD_DEPS = $(DEV_DEPS:dev.%=prod.%)

# COMMANDS
CLEAN.CMD        = rm $(CLEAN.FLAGS)
CLEAN.FLAGS     := -rf

COFFEE.CMD       = coffee $(COFFEE.FLAGS)
COFFEE.FLAGS    := --compile --no-header

JADE.CMD         = jade $(JADE.FLAGS)
JADE.FLAGS      := --pretty

MKDIRS.CMD       = mkdir $(MKDIRS.FLAGS)
MKDIRS.FLAGS    := -p

STYLUS.CMD       = stylus $(STYLUS.FLAGS)
STYLUS.FLAGS    := --use 'nib'
STYLUS.FLAGS    += --include-css

UGLIFY.CMD       = uglifyjs $(UGLIFY.FLAGS)
UGLIFY.FLAGS    := --mangle
UGLIFY.FLAGS    += --compress

all: prod

dev: | $(DEV_DEPS)

dev.dirs:
	$(MKDIRS.CMD) $(BUILD.DIRS)

dev.setup:
	cp $(SRC.IMG_DIR)/* $(BUILD.IMG_DIR)/
	cp $(SRC.FONT_DIR)/* $(BUILD.FONT_DIR)/
	cp $(SRC.VENDOR_DIR)/*.js $(BUILD.JS_DIR)/

dev.coffee:
	$(COFFEE.CMD) --watch --output $(BUILD.JS_DIR) $(SRC.COFFEE_DIR)

dev.jade:
	$(JADE.CMD) --watch $(SRC.JADE_DIR)/*.jade --out $(BUILD.DIR)

dev.styl:
	$(STYLUS.CMD) --watch $(SRC.STYLUS_DIR) --out $(BUILD.CSS_DIR)

prod: | $(PROD_DEPS)
	@echo -e '\033[32mBuild Complete!\033[0m'

prod.dirs:
	@$(MKDIRS.CMD) $(BUILD.DIRS)

prod.coffee:
	@echo -e '\033[33mCompiling CoffeeScript...\033[0m'
	@$(COFFEE.CMD) --output $(BUILD.JS_DIR) $(SRC.COFFEE_DIR) > /dev/null
	@#$(UGLIFY.CMD) [<files to uglify>] --output <outputFile.min.js> > /dev/null

prod.jade:
	@echo -e '\033[33mCompiling Jade...\033[0m'
	@$(JADE.CMD) $(SRC.JADE_DIR) --out $(BUILD.DIR) > /dev/null

prod.styl:
	@echo -e '\033[33mCompiling Stylus...\033[0m'
	@$(STYLUS.CMD) --compress $(SRC.STYLUS_DIR) --out $(BUILD.CSS_DIR) > /dev/null

clean:
	@echo -e '\033[33mCleaning Project...\033[0m'
	@$(CLEAN.CMD)\
		$(BUILD.DIR)
	@echo -e '\033[32mProject Clean!\033[0m'
