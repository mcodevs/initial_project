DEVELOPMENT_CONFIG := config/development.json
PRODUCTION_CONFIG := config/production.json

INCREMENT_BUILD = perl -0pi -e 's/^version:\s*([^+\n]+)\+([0-9]+)$$/"version: $$1+" . ($$2 + 1)/me' pubspec.yaml
check_config = test -f "$(1)" || (echo "Config file not found: $(1)"; exit 1)

.PHONY: help get clean format analyze test run increment-build
.PHONY: apk apk-prod aab ipa ipa-prod

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

get: ## Get Flutter dependencies
	@flutter pub get

clean: ## Clean Flutter build artifacts
	@flutter clean

format: ## Format Dart source files
	@dart format -l 120 lib/ test/

analyze: ## Run Flutter analyzer
	@flutter analyze

test: ## Run Flutter tests
	@flutter test

run: ## Run the app
	@flutter run

increment-build: ## Increment pubspec.yaml build number
	@$(INCREMENT_BUILD)
	@echo "Updated $$(grep '^version:' pubspec.yaml)"

apk: ## Build release Android APK with development config
	@flutter clean
	@$(call check_config,$(DEVELOPMENT_CONFIG))
	@$(INCREMENT_BUILD)
	@echo "Updated $$(grep '^version:' pubspec.yaml)"
	@flutter build apk --release --dart-define-from-file=$(DEVELOPMENT_CONFIG)

apk-prod: ## Build release Android APK with production config
	@flutter clean
	@$(call check_config,$(PRODUCTION_CONFIG))
	@$(INCREMENT_BUILD)
	@echo "Updated $$(grep '^version:' pubspec.yaml)"
	@flutter build apk --release --dart-define-from-file=$(PRODUCTION_CONFIG)

aab: ## Build release Android App Bundle with production config
	@flutter clean
	@$(call check_config,$(PRODUCTION_CONFIG))
	@$(INCREMENT_BUILD)
	@echo "Updated $$(grep '^version:' pubspec.yaml)"
	@flutter build appbundle --release --dart-define-from-file=$(PRODUCTION_CONFIG)

ipa: ## Build release iOS IPA with development config
	@flutter clean
	@$(call check_config,$(DEVELOPMENT_CONFIG))
	@$(INCREMENT_BUILD)
	@echo "Updated $$(grep '^version:' pubspec.yaml)"
	@flutter build ipa --release --dart-define-from-file=$(DEVELOPMENT_CONFIG)

ipa-prod: ## Build release iOS IPA with production config
	@flutter clean
	@$(call check_config,$(PRODUCTION_CONFIG))
	@$(INCREMENT_BUILD)
	@echo "Updated $$(grep '^version:' pubspec.yaml)"
	@flutter build ipa --release --dart-define-from-file=$(PRODUCTION_CONFIG)
