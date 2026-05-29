# =============================================================================
# Makefile — Flutter Project Build & Automation
# =============================================================================
#
# Usage:
#   make <target>
#   make help          — list all documented targets
#
# Configurable variables (override via env or CLI, e.g. FLUTTER=fvm flutter):
#   FLUTTER            — path to the Flutter CLI   (default: flutter)
#   DART               — path to the Dart CLI      (default: dart)
#   VECTOR_RECURSIVE   — recurse into SVG subdirs  (default: false, shorthand: r)
#
# Structure:
#   This root Makefile defines shared variables and macros, then includes
#   target modules from tools/makefile/*.mk:
#
#     general.mk      — get, clean, format, analyze, test, run
#     deps.mk         — upgrade, outdated, dependencies
#     build.mk        — apk, aab, ipa (Android & iOS release builds)
#     codegen.mk      — increment-build, fluttergen, icons, splash, l10n
#     vectors.mk      — SVG → vector asset compilation
#     maintenance.mk  — fcg, pod-restart, clear_gradle
#
# =============================================================================

# ---------------------------------------------------------------------------
# Tools — allow overriding via environment or command-line
# ---------------------------------------------------------------------------
FLUTTER ?= flutter
DART    ?= dart

# ---------------------------------------------------------------------------
# Paths & configuration
# ---------------------------------------------------------------------------
CONFIG_DIR          := config
DEVELOPMENT_CONFIG  := $(CONFIG_DIR)/development.json
STAGING_CONFIG      := $(CONFIG_DIR)/staging.json
PRODUCTION_CONFIG   := $(CONFIG_DIR)/production.json
PUBSPEC             := pubspec.yaml

# Flutter build output directories (opened in Finder after build)
APK_OUTPUT_DIR      := build/app/outputs/apk/release/
AAB_OUTPUT_DIR      := build/app/outputs/bundle/release/
IPA_OUTPUT_DIR      := build/ios/archive/Runner.xcarchive

# Dart formatter settings
FORMAT_LINE_LENGTH  := 120
# NOTE: $(wildcard ...) silently drops entries that don't exist on disk,
# so only directories actually present are formatted.
FORMAT_PATHS        := $(wildcard lib test tools packages)

# Gradle cache directories (for clear_gradle)
GRADLE_CACHE_DIRS   := $(HOME)/.gradle/caches $(HOME)/.gradle/wrapper $(HOME)/.gradle/daemon

# Localization (l10n) settings
L10N_ARB_DIR        := lib/src/common/localization
L10N_OUTPUT_DIR     := $(L10N_ARB_DIR)/generated
L10N_TEMPLATE       := intl_ru.arb

# Vector graphics generation — `r=true` as shorthand for VECTOR_RECURSIVE=true
VECTOR_RECURSIVE    ?= false
r                   ?= $(VECTOR_RECURSIVE)

# ---------------------------------------------------------------------------
# Internal helper macros (shared across all modules)
# ---------------------------------------------------------------------------

# Bump the build number in pubspec.yaml (e.g. 1.0.0+2 → 1.0.0+3)
INCREMENT_BUILD = perl -0pi -e \
	's/^version:\s*([^+\n]+)\+([0-9]+)$$/"version: $$1+" . ($$2 + 1)/me' $(PUBSPEC)

# Guard: abort if the given config file is missing
#   $(call check_config,path/to/config.json)
check_config = test -f "$(1)" || { echo "Error: Config file not found: $(1)"; exit 1; }

# Pretty-print the new version string after a build-number bump
print_version = echo "Updated $$(grep '^version:' $(PUBSPEC))"

# ---------------------------------------------------------------------------
# build_release — reusable macro for all release builds
#   $(call build_release,<flutter-build-type>,<config-file>,<output-dir>)
#   e.g. $(call build_release,apk,config/development.json,$(APK_OUTPUT_DIR))
#
# Steps:
#   1. Clean previous artifacts
#   2. Verify the config file exists
#   3. Increment the build number
#   4. Build in --release mode with --dart-define-from-file
#   5. Open the output folder in Finder (macOS)
# ---------------------------------------------------------------------------
define build_release
	@$(FLUTTER) clean
	@$(call check_config,$(2))
	@$(INCREMENT_BUILD)
	@$(call print_version)
	@$(FLUTTER) build $(1) --release --dart-define-from-file=$(2)
	@echo "\033[32m✓ Build complete — opening output folder\033[0m"
	@open $(3)
endef

# ---------------------------------------------------------------------------
# Default goal — show help when running bare `make`
# ---------------------------------------------------------------------------
.DEFAULT_GOAL := help

# Collect ## comments from all included files for the help target
help: ## Show available commands
	@grep -hE '^[[:alnum:]_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

# ---------------------------------------------------------------------------
# Include target modules
# ---------------------------------------------------------------------------
include tools/makefile/general.mk
include tools/makefile/deps.mk
include tools/makefile/build.mk
include tools/makefile/codegen.mk
include tools/makefile/vectors.mk
include tools/makefile/maintenance.mk
include tools/makefile/git.mk
