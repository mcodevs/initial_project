# =============================================================================
#  Dependency Management
# =============================================================================

.PHONY: upgrade upgrade-major outdated dependencies

upgrade: ## Upgrade all dependencies (compatible versions)
	@$(FLUTTER) pub upgrade

upgrade-major: get ## Upgrade to latest major versions
	@$(FLUTTER) pub upgrade --major-versions

outdated: get ## Check for outdated dependencies
	@$(FLUTTER) pub outdated

dependencies: get ## Show all outdated deps (incl. overrides, dev, prereleases)
	@$(FLUTTER) pub outdated --dependency-overrides \
		--dev-dependencies --prereleases --show-all --transitive
