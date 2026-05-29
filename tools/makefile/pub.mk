# ──────────────────────────────────
# 📖 HELPERS
# ──────────────────────────────────
.PHONY: help-pub
help-pub: ## Show all available pub commands with descriptions
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# ──────────────────────────────────
# 🔎 PROJECT INFORMATION
# ──────────────────────────────────
.PHONY: version
version: ## Check Flutter version
	######## ##       ##     ## ######## ######## ######## ########
	##       ##       ##     ##    ##       ##    ##       ##     ##
	##       ##       ##     ##    ##       ##    ##       ##     ##
	######   ##       ##     ##    ##       ##    ######   ########
	##       ##       ##     ##    ##       ##    ##       ##   ##
	##       ##       ##     ##    ##       ##    ##       ##    ##
	##       ########  #######     ##       ##    ######## ##     ##
	@fvm flutter --version

# ──────────────────────────────────
# 🧹 CLEANING COMMANDS
# ──────────────────────────────────
.PHONY: clean_all
clean_all: ## Clean the project and remove all generated files
	@echo "🗑️ Cleaning the project..."
	@$(MAKE) clean
	@$(MAKE) clear_gradle
	@rm -f coverage.*
	@rm -rf dist bin out build
	@rm -rf coverage .dart_tool .packages pubspec.lock
	@echo "✅ Project successfully cleaned"

.PHONY: fcg
fcg: ## Flutter clean, get dependencies, and format
	@$(MAKE) clean
	@$(MAKE) get
	@$(MAKE) format

.PHONY: c_get
c_get: clean_all get ## Clean all and get dependencies

.PHONY: clean
clean: ## Clean the project
	@flutter clean

# ──────────────────────────────────
# 📦 DEPENDENCY MANAGEMENT
# ──────────────────────────────────
.PHONY: upgrade
upgrade: ## Upgrade all dependencies
	@flutter pub upgrade

.PHONY: upgrade-major
upgrade-major: get ## Upgrade to major versions
	@flutter pub upgrade --major-versions

.PHONY: outdated
outdated: get ## Check for outdated dependencies
	@flutter pub outdated

.PHONY: dependencies
dependencies: get ## Check all types of outdated dependencies
	@flutter pub outdated --dependency-overrides \
		--dev-dependencies --prereleases --show-all --transitive

.PHONY: get
get: ## Get dependencies
	@flutter pub get

# ──────────────────────────────────
# 🎨 CODE STYLE & FORMATTING
# ──────────────────────────────────
.PHONY: format
format: ## Format Dart code to line length 120
	@dart format -l 120 lib/ test/ package/ tools/

# ──────────────────────────────────
# ⚡ CODE GENERATION
# ──────────────────────────────────
.PHONY: fluttergen
fluttergen: ## Generate assets with flutter_gen
	@dart run build_runner build --delete-conflicting-outputs

.PHONY: l10n
l10n: ## Generate localization files
	@dart pub global activate intl_utils
	@(dart pub global run intl_utils:generate)
	@(flutter gen-l10n --arb-dir lib/src/common/localization --output-dir lib/src/common/localization/generated --template-arb-file intl_ru.arb)

.PHONY: build_runner
build_runner: ## Run build_runner to generate code
	@dart run build_runner build --delete-conflicting-outputs --release

.PHONY: gen
gen: ## Run all code generation tasks
	@echo "🔄 Generating code..."
	@flutter pub get
	@$(MAKE) fluttergen
	@$(MAKE) l10n
	@$(MAKE) build_runner
	@$(MAKE) format
	@# `clear` CI/non-interactive muhitlarda exit 1 qaytarishi mumkin (TERM yo‘q).
	@if [ -t 1 ]; then clear; fi
	@echo "✅ Code generated successfully"

# ──────────────────────────────────
# 🎨 VECTOR GRAPHICS
# ──────────────────────────────────
.PHONY: build_vec
build_vec: ## Build vector graphics from SVG files
	@dart run tools/dart/vector_generator.dart $(r)

vec: r ?= false	
vec: build_vec fluttergen format ## Build vectors and regenerate assets

# ──────────────────────────────────
# 📱 APP RESOURCES
# ──────────────────────────────────
.PHONY: generate-icons
generate-icons: ## Generate app icons (flutter_launcher_icons)
	@dart run flutter_launcher_icons -f flutter_launcher_icons.yaml

.PHONY: generate-splash
generate-splash: ## Generate splash screen (flutter_native_splash)
	@dart run flutter_native_splash:create --path=flutter_native_splash.yaml

# ──────────────────────────────────
# 🍎 iOS SPECIFIC
# ──────────────────────────────────
.PHONY: pod-restart
pod-restart: ## Restart CocoaPods for iOS project
	@cd ios && \
	rm -rf Pods && \
	rm Podfile.lock && \
	pod deintegrate && \
	pod install
	@cd ..
	@$(MAKE) fcg

.PHONY: clear_gradle
clear_gradle: ## Clear Gradle cache
	@rm -rf ~/.gradle/caches/
	@rm -rf ~/.gradle/wrapper/
	@rm -rf ~/.gradle/daemon/
	@rm -rf ~/.gradle/daemon/
