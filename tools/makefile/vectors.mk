# =============================================================================
#  Vector Graphics — SVG → optimized vector assets
# =============================================================================

.PHONY: build_vec vec

build_vec: ## Compile SVG files to vector graphics
	@$(DART) run tools/dart/vector_generator.dart $(r)

vec: ## Build vectors → regenerate assets → format
	@$(MAKE) build_vec
	@$(MAKE) fluttergen
	@$(MAKE) format
