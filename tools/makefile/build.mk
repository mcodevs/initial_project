# =============================================================================
#  Build Targets — Android & iOS release builds
# =============================================================================
#
# All targets use the `build_release` macro defined in the root Makefile.
# After a successful build the output folder is opened in Finder.
#
# =============================================================================

.PHONY: apk apk-staging apk-prod aab aab-staging ipa ipa-prod

# --- Android -----------------------------------------------------------------

apk: ## Build release APK (development config)
	$(call build_release,apk,$(DEVELOPMENT_CONFIG),$(APK_OUTPUT_DIR))

apk-staging: ## Build release APK (staging config)
	$(call build_release,apk,$(STAGING_CONFIG),$(APK_OUTPUT_DIR))

apk-prod: ## Build release APK (production config)
	$(call build_release,apk,$(PRODUCTION_CONFIG),$(APK_OUTPUT_DIR))

aab: ## Build release App Bundle (production config)
	$(call build_release,appbundle,$(PRODUCTION_CONFIG),$(AAB_OUTPUT_DIR))

aab-staging: ## Build release App Bundle (staging config)
	$(call build_release,appbundle,$(STAGING_CONFIG),$(AAB_OUTPUT_DIR))

# --- iOS ---------------------------------------------------------------------

ipa: ## Build release IPA (development config)
	$(call build_release,ipa,$(DEVELOPMENT_CONFIG),$(IPA_OUTPUT_DIR))

ipa-prod: ## Build release IPA (production config)
	$(call build_release,ipa,$(PRODUCTION_CONFIG),$(IPA_OUTPUT_DIR))
