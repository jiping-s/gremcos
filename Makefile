.DEFAULT_GOAL := all

all: test lint finish

# This target (taken from: https://gist.github.com/prwhite/8168133) is an easy way to print out a usage/ help of all make targets.
# For all make targets the text after \#\# will be printed.
help: ## Prints the help
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\1\:\2/' | column -c2 -t -s :)"

test: sep ## Runs all unittests and generates a coverage report.
	@echo "--> Run the unit-tests"
	@go test -timeout 30s $$(go list ./... | grep -v "/test$" | grep -v "/interfaces$") -covermode=count

lint: ## Runs the linter to check for coding-style issues
	@echo "--> Lint project"
	@echo "!!!!golangci-lint has to be installed. See: https://github.com/golangci/golangci-lint#install"
	@golangci-lint run --fast

infra.up: ## Starts up the infra components
	make -C infra up

infra.down: ## Stops up the infra components
	make -C infra down

sep:
	@echo "----------------------------------------------------------------------------------"

finish:
	@echo "=================================================================================="
