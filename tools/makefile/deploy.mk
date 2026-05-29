# ──────────────────────
# 🚀 DEPLOYMENT COMMANDS
# ──────────────────────

# Build Name and Number from pubspec.yaml
BUILD_NAME=$(shell grep '^version: ' pubspec.yaml | cut -d+ -f1 | sed 's/version: //')
BUILD_NUMBER=$(shell grep '^version: ' pubspec.yaml | cut -d+ -f2)

.PHONY: help-deploy
help-deploy: ## Show all available deployment-related commands
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: pre-build
pre-build: ## Run before build tasks
	@$(MAKE) increment-build
	@$(MAKE) clean_all
	@$(MAKE) get
	@$(MAKE) gen

# ─────────── VERSION MANAGEMENT ───────────

.PHONY: increment-build
increment-build: ## Increment build number in pubspec.yaml
	@sed -i '' 's/\(^version: *[0-9.]*\)+\([0-9]*\)/\1+'"$$(($$(grep '^version:' pubspec.yaml | cut -d+ -f2) + 1))"'/' pubspec.yaml
	@echo "\nBuild number incremented to $$(($(BUILD_NUMBER) + 1))\n"

# ─────────── BUILD COMMANDS FOR ANDROID ───────────

.PHONY: apk
apk: pre-build ## Build Android APK (development config)
	@flutter build apk --release --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER) --dart-define-from-file=config/development.json
	@open build/app/outputs/apk/release/

.PHONY: apk-staging
apk-staging: pre-build ## Build Android APK (staging config)
	@flutter build apk --release --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER) --dart-define-from-file=config/staging.json
	@open build/app/outputs/apk/release/

.PHONY: apk-prod
apk-prod: pre-build ## Build Android APK (production config)
	@dart run build_runner build --delete-conflicting-outputs
	@flutter build apk --release --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER) --dart-define-from-file=config/production.json
	@open build/app/outputs/apk/release/

# ─────────── BUILD COMMANDS FOR ANDROID aab ───────────
.PHONY: aab
aab: pre-build ## Build Android AAB (production config)
	@flutter build appbundle --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER) --dart-define-from-file=config/production.json
	@open build/app/outputs/bundle/release/

# ─────────── BUILD COMMANDS FOR iOS ───────────

.PHONY: ipa
ipa: pre-build ## Build iOS IPA (development config)
	@flutter build ipa --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER) --dart-define-from-file=config/development.json
	@open build/ios/archive/Runner.xcarchive

.PHONY: ipa-staging
ipa-staging: pre-build ## Build iOS IPA (staging config)
	@flutter build ipa --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER) --dart-define-from-file=config/staging.json
	@open build/ios/archive/Runner.xcarchive

.PHONY: ipa-prod
ipa-prod: pre-build ## Build iOS IPA (production config)
	@dart run build_runner build --delete-conflicting-outputs
	@flutter build ipa --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER) --dart-define-from-file=config/production.json
	@open build/ios/archive/Runner.xcarchive
