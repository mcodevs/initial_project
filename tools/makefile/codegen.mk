# =============================================================================
#  Code Generation — assets, icons, splash, l10n
# =============================================================================

.PHONY: increment-build fluttergen generate-icons generate-splash l10n

increment-build: ## Increment pubspec.yaml build number (+1)
	@$(INCREMENT_BUILD)
	@$(call print_version)

fluttergen: ## Run build_runner to generate assets / code
	@$(DART) run build_runner build --delete-conflicting-outputs

generate-icons: ## Generate app launcher icons (flutter_launcher_icons)
	@$(DART) run flutter_launcher_icons -f flutter_launcher_icons.yaml

generate-splash: ## Generate native splash screen (flutter_native_splash)
	@$(DART) run flutter_native_splash:create --path=flutter_native_splash.yaml

l10n: ## Generate localization files (intl_utils + gen-l10n)
	@$(DART) pub global activate intl_utils
	@$(DART) pub global run intl_utils:generate
	@$(FLUTTER) gen-l10n \
		--arb-dir $(L10N_ARB_DIR) \
		--output-dir $(L10N_OUTPUT_DIR) \
		--template-arb-file $(L10N_TEMPLATE)
