# =============================================================================
#  General — everyday development commands
# =============================================================================

.PHONY: get clean format analyze test run

get: ## Get Flutter dependencies
	@$(FLUTTER) pub get

clean: ## Clean Flutter build artifacts
	@$(FLUTTER) clean

format: ## Format Dart source files (line length: $(FORMAT_LINE_LENGTH))
	@$(DART) format -l $(FORMAT_LINE_LENGTH) $(FORMAT_PATHS)

analyze: ## Run Flutter static analyzer
	@$(FLUTTER) analyze

test: ## Run Flutter tests
	@$(FLUTTER) test

run: ## Run the app in debug mode
	@$(FLUTTER) run
