#
# one-shot-ios — iOS scaffolder
#

RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
RESET := \033[0m

CHECK := ✅
WRENCH := 🛠️
TEST := 🧪
SPARK := ✨

.DEFAULT_GOAL := help

REPO_ROOT := $(shell pwd)
TEMPLATE_DIR := $(REPO_ROOT)/template
SCAFFOLD := $(REPO_ROOT)/bin/scaffold.sh
SCRATCH := /tmp/one-shot-ios-scaffold-check

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: new
new: ## ✨ Scaffold a new iOS project (interactive prompts)
	@$(SCAFFOLD)

.PHONY: lint-template
lint-template: ## 🛠️  Verify template tokens are only used in expected shapes
	@echo "$(BLUE)$(WRENCH) Linting template...$(RESET)"
	@if grep -R --line-number --binary-files=without-match \
		--exclude-dir='.build' --exclude-dir='.claude' --exclude-dir='__Snapshots__' \
		-E '__[A-Z_]+__' $(TEMPLATE_DIR) \
		| grep -v -E '__(APP_NAME|BUNDLE_ID|PLATFORMS|DEPLOYMENT_TARGETS)__' ; then \
		echo "$(RED)✗ Unknown placeholder token found in template (see lines above)$(RESET)"; \
		exit 1; \
	fi
	@echo "$(GREEN)$(CHECK) Template placeholders look sane$(RESET)"

.PHONY: test-scaffold
test-scaffold: lint-template ## 🧪 Run the scaffolder into a temp dir and grep for leftover tokens
	@echo "$(BLUE)$(TEST) Scaffolding into $(SCRATCH)...$(RESET)"
	@rm -rf $(SCRATCH)
	@$(SCAFFOLD) \
		--app-name DemoApp \
		--bundle-id com.example.demo \
		--platforms iOS \
		--target-dir $(SCRATCH) \
		--no-git
	@echo "$(BLUE)$(TEST) Checking for leftover placeholder tokens...$(RESET)"
	@if grep -R --line-number --binary-files=without-match -E '__(APP_NAME|BUNDLE_ID|PLATFORMS|DEPLOYMENT_TARGETS)__' $(SCRATCH) ; then \
		echo "$(RED)✗ Leftover tokens in scaffold output$(RESET)"; \
		exit 1; \
	fi
	@echo "$(GREEN)$(CHECK) Scaffold produced clean output$(RESET)"
	@echo "$(YELLOW)   Output kept at $(SCRATCH) for inspection. Remove with: rm -rf $(SCRATCH)$(RESET)"

.PHONY: clean
clean: ## Remove scaffold scratch dir
	@rm -rf $(SCRATCH)
	@echo "$(GREEN)$(CHECK) Removed $(SCRATCH)$(RESET)"
