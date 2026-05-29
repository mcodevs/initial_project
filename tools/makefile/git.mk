# =============================================================================
#  Git — tagging & version management
# =============================================================================

# Extract version from pubspec.yaml (e.g. "1.0.0+2" → "1.0.0+2")
PUBSPEC_VERSION = $(shell grep '^version:' $(PUBSPEC) | awk '{print $$2}')
# Strip the build number (e.g. "1.0.0+2" → "1.0.0")
PUBSPEC_VERSION_NAME = $(shell echo $(PUBSPEC_VERSION) | sed 's/+.*//')

.PHONY: tag-prod

tag-prod: format ## Create and push a Git tag for production (from pubspec.yaml)
	@echo "\033[36m🏷️  Tagging v$(PUBSPEC_VERSION_NAME) (full: $(PUBSPEC_VERSION))\033[0m"
	@git tag -a "v$(PUBSPEC_VERSION_NAME)" -m "Release v$(PUBSPEC_VERSION_NAME) (build $(PUBSPEC_VERSION))"
	@echo "\033[32m📤 Pushing tags to remote...\033[0m"
	@git push origin --tags
	@echo "\033[32m✓ Tag v$(PUBSPEC_VERSION_NAME) pushed successfully\033[0m"
