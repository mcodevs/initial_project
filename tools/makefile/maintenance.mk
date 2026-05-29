# =============================================================================
#  Maintenance / Housekeeping
# =============================================================================

.PHONY: fcg pod-restart clear_gradle

fcg: ## Full clean → get deps → format (shorthand refresh)
	@$(MAKE) clean
	@$(MAKE) get
	@$(MAKE) format

pod-restart: ## Wipe & reinstall CocoaPods, then refresh project
	@test -d ios || { echo "Error: ios/ directory not found"; exit 1; }
	@cd ios && \
		rm -rf Pods && \
		rm -f Podfile.lock && \
		pod deintegrate && \
		pod install
	@$(MAKE) fcg

clear_gradle: ## Delete Gradle caches (~/.gradle/{caches,wrapper,daemon})
	@rm -rf $(GRADLE_CACHE_DIRS)
