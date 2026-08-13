#
# __APP_NAME__
#

RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
RESET := \033[0m

CHECK := ✅
WRENCH := 🛠️
TEST := 🧪
PACKAGE := 📦

.DEFAULT_GOAL := help

DEVICE := "iPhone 17 Pro"
TARGET ?= __APP_NAME__
SCHEME := __APP_NAME__-Workspace
UNIT_TEST_TARGETS := __APP_NAME__Tests ExampleFeatureTests
SNAPSHOT_TEST_TARGETS := __APP_NAME__SnapshotTests ExampleFeatureSnapshotTests

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: setup
setup: ## $(WRENCH) Install and verify required tools (Xcode, Tuist)
	@./scripts/setup.sh

.PHONY: project
project: ## $(PACKAGE) Generate Xcode project with Tuist
	@echo "$(BLUE)$(PACKAGE) Generating Xcode project...$(RESET)"
	@tuist install
	@tuist generate $(if $(NO_OPEN),--no-open) $(if $(filter 1,$(VERBOSE)),--verbose)
	@echo "$(GREEN)$(CHECK) Project generated successfully!$(RESET)"

.PHONY: build
build: ## $(WRENCH) Build the project (TARGET=__APP_NAME__ by default)
	@echo "$(BLUE)$(WRENCH) Building $(TARGET)...$(RESET)"
	@tuist build $(TARGET)
	@echo "$(GREEN)$(CHECK) Build succeeded!$(RESET)"

.PHONY: unit-test
unit-test: ## $(TEST) Run unit tests (FILTER=Target[/Suite[/case]] to scope)
	@echo "$(BLUE)$(TEST) Running unit tests...$(RESET)"
	@tuist test $(SCHEME) --device $(DEVICE) --no-selective-testing \
		$(if $(FILTER),--test-targets=$(FILTER),$(addprefix --test-targets=,$(UNIT_TEST_TARGETS)))
	@echo "$(GREEN)$(CHECK) Unit tests passed!$(RESET)"

.PHONY: snapshot-test
snapshot-test: ## $(TEST) Run snapshot tests (REPLACE=1 to re-record baselines, FILTER=... to scope)
	@echo "$(BLUE)$(TEST) Running snapshot tests$(if $(REPLACE), (record mode))...$(RESET)"
	@tuist test $(if $(REPLACE),Snapshots-Record,Snapshots) --device $(DEVICE) --no-selective-testing \
		$(if $(FILTER),--test-targets=$(FILTER))
	@echo "$(GREEN)$(CHECK) Snapshot tests passed!$(RESET)"

.PHONY: test
test: unit-test snapshot-test ## $(TEST) Run all tests (unit + snapshot)
