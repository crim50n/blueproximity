.PHONY: all build binary clean locales install

# --- Automatic variable detection ---
PACKAGE = $(shell dpkg-parsechangelog -S Source)
UPSTREAM_VERSION = $(shell dpkg-parsechangelog -S Version | sed 's/-[^-]*$$//')

# --- Build environment variables ---
BUILD_DIR := build
# Target directory for prepared sources
BUILD_SRC_DIR := $(BUILD_DIR)/$(PACKAGE)-$(UPSTREAM_VERSION)
# Target directory for compiled locales within the prepared sources
LANG_DIR := $(BUILD_DIR)/LANG
# Target file: final source archive
ORIG_TARBALL := $(BUILD_DIR)/$(PACKAGE)_$(UPSTREAM_VERSION).orig.tar.gz
# Target file: "stamp" confirming that 'debian' directory was copied
DEBIAN_STAMP := $(BUILD_SRC_DIR)/.debian_copied.stamp


# --- Main target hierarchy ---

# Default main target
all: build

# User target: build binary package
build: clean binary

# Добавлена зависимость от 'locales'
binary: $(ORIG_TARBALL) $(DEBIAN_STAMP) locales
	@echo "--- 4. Running dpkg-buildpackage ---"
	@echo "     Packages will be created in the '$(BUILD_DIR)' directory"
	@(cd $(BUILD_SRC_DIR) && dpkg-buildpackage -us -uc -b)
	@echo "--- Build finished! ---"


# --- Targets describing artifact creation ---

# 1. Target for creating the archive. Depends on prepared source directory.
$(ORIG_TARBALL): $(BUILD_SRC_DIR)
	@echo "--- 2. Creating source archive: $(ORIG_TARBALL) ---"
	@tar -C $(BUILD_DIR) --owner=root --group=root -czf $@ $(PACKAGE)-$(UPSTREAM_VERSION)

# 2. Target for copying 'debian'. Depends on build directory.
#    Creates an empty stamp file to mark the action as done.
$(DEBIAN_STAMP): $(BUILD_SRC_DIR)
	@echo "--- 3. Copying 'debian' directory to build directory ---"
	@cp -r debian $(BUILD_SRC_DIR)/
	@touch $@

$(BUILD_SRC_DIR):
	@echo "--- 1. Creating build directory and copying sources ---"
	@mkdir -p $(BUILD_SRC_DIR)
	@rsync -a --delete --exclude='.git' --exclude='debian' --exclude='Makefile' --exclude='$(BUILD_DIR)' ./ $(BUILD_SRC_DIR)/


# --- Auxiliary targets ---

locales: $(BUILD_SRC_DIR)
	@echo "--- Compiling locales to $(LANG_DIR) ---"
	@if [ -d "po" ]; then \
	  mkdir -p $(LANG_DIR); \
	  for lang_file in po/*.po; do \
		lang=$$(basename "$$lang_file" .po); \
		install_dir="$(LANG_DIR)/$$lang/LC_MESSAGES"; \
		mkdir -p "$$install_dir"; \
		msgfmt -o "$$install_dir/blueproximity.mo" "$$lang_file"; \
		echo "  - compiled $$lang_file to $(LANG_DIR)"; \
	  done; \
	else \
	  echo "No 'po' directory found, skipping locale generation."; \
	fi

# Target for complete cleanup of all build artifacts.
clean:
	@echo "--- Cleaning project ---"
	@dh_clean
	@rm -rf $(BUILD_DIR)


# --- Install to system ---
install:
	@echo "--- Installing BlueProximity to system ---"
	install -d /usr/share/blueproximity/
	install -m 644 proximity.py proximity.glade blueproximity_attention.svg blueproximity_base.svg blueproximity_error.svg blueproximity_nocon.svg blueproximity_pause.svg /usr/share/blueproximity/
	install -d /usr/share/applications/
	install -m 644 addons/blueproximity.desktop /usr/share/applications/blueproximity.desktop
	install -d /usr/share/pixmaps/
	install -m 644 addons/blueproximity.xpm /usr/share/pixmaps/blueproximity.xpm
	install -d /usr/bin/
	install -m 755 addons/blueproximity /usr/bin/blueproximity
	install -d /usr/share/doc/blueproximity/
	install -m 644 README.md CHANGELOG LICENSE /usr/share/doc/blueproximity/
	install -d /usr/share/man/man1/
	install -m 644 doc/blueproximity.1 /usr/share/man/man1/blueproximity.1
	@echo "--- Installing translations (.mo files) ---"
	@if [ -d "po" ]; then \
	  for lang_file in po/*.po; do \
		lang=$$(basename "$$lang_file" .po); \
		install_dir="/usr/share/locale/$$lang/LC_MESSAGES"; \
		mkdir -p "$$install_dir"; \
		msgfmt -o "$$install_dir/blueproximity.mo" "$$lang_file"; \
		echo "  - compiled $$lang_file"; \
	  done; \
	else \
	  echo "No 'po' directory found, skipping locale generation."; \
	fi