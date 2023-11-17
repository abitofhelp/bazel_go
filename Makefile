# Makefile

PROJECT_NAME=bazel_go
PROJECT_DIR=$(GOPATH)/src/github.com/abitofhelp/$(PROJECT_NAME)
MODULE_NAME=github.com/abitofhelp/$(PROJECT_NAME)

BZLCMD=bazel
BAZEL_BUILD_OPTS:=--verbose_failures --sandbox_debug
GOCMD=$(BZLCMD) run @io_bazel_rules_go//go
CMD_DIR=$(PROJECT_DIR)/cmd
CMD_WORKSPACE=//cmd
CMD_TARGET=$(CMD_WORKSPACE):cmd

build_all:
	$(BZLCMD) build $(BAZEL_BUILD_OPTS) //...

build_cmd:
	$(BZLCMD) build $(BAZEL_BUILD_OPTS) //cmd:cmd

clean:
	$(BZLCMD) clean --expunge --async

expand_golang_build:
	$(BZLCMD) query $(CMD_TARGET) --output=build

gazelle_generate_repos:
#	 This will generate new BUILD.bazel files for your project. You can run the same command in the future to update existing BUILD.bazel files to include new source files or options.
	$(BZLCMD) run $(BAZEL_BUILD_OPTS) //:gazelle

gazelle_update_repos:
	# Import repositories from go.mod and update Bazel's macro and rules.
	$(BZLCMD) run $(BAZEL_BUILD_OPTS) //:gazelle -- update-repos -from_file="cmd/go.mod" -to_macro="go_deps.bzl%go_dependencies" -prune

go_build_all:
	## N.B. Each go.mod file defines a workspace in which the go build, go test, go list, and go get commands are available.  These commands apply to packages only within that workspace.
	## This is why you cannot use go build ./... with a multimodule workspace.
	# Assumes GO111MODULE=on
	pushd $(CMD_DIR) && \
	$(GOCMD) -- build ./... && \
	popd;

go_mod_download:
	## N.B. Each go.mod file defines a workspace in which the go build, go test, go list, and go get commands are available.  These commands apply to packages only within that workspace.
	# Assumes GO111MODULE=on
	pushd "$(CMD_DIR)" && \
	$(GOCMD) -- mod download && \
	popd;

go_mod_tidy:
	## N.B. Each go.mod file defines a workspace in which the go build, go test, go list, and go get commands are available.  These commands apply to packages only within that workspace.
	# Assumes GO111MODULE=on
	pushd "$(CMD_DIR)" && \
	$(GOCMD) -- mod tidy && \
	popd;

go_mod_vendor:
	rm -rf vendor
	## N.B. Each go.mod file defines a workspace in which the go build, go test, go list, and go get commands are available.  These commands apply to packages only within that workspace.
	# Assumes GO111MODULE=on
	pushd "$(CMD_DIR)" && \
	$(GOCMD) -- mod vendor -v && \
	popd;

go_mod_verify:
	## Verify that the go.sum file matches what was downloaded to prevent someone “git push — force” over a tag being used.
    ## N.B. Each go.mod file defines a workspace in which the go build, go test, go list, and go get commands are available.  These commands apply to packages only within that workspace.
	# Assumes GO111MODULE=on
	pushd "$(CMD_DIR)" && \
	$(GOCMD) -- mod verify && \
	popd;

go_targets:
	$(BZLCMD) query "@io_bazel_rules_go//go:*"

go_unit_test:
	# Assumes GO111MODULE=on
	pushd "$(CMD_DIR)" && \
	$(GOCMD) -- test  && \
	popd;

list_targets:
	$(BZLCMD) query //...

set_golang_version:
	sed -E -i '.org' 's/go 1.21.3/go 1.21.4/g' "$(PROJECT_DIR)/go.work" && rm "$(PROJECT_DIR)/go.work.org" && \
	sed -E -i '.org' 's/go 1.21.3/go 1.21.4/g' "$(CMD_DIR)/go.mod" && rm "$(CMD_DIR)/go.mod.org" && \
	sed -E -i '.org' 's/GO_VERSION = "1.21.3"/GO_VERSION = "1.21.4"/g' "$(PROJECT_DIR)/WORKSPACE" && rm "$(PROJECT_DIR)/WORKSPACE.org" ;

## The generate_repos at the end of the command string is not an error.
## Verify the BUILD.bazel files that have been changed.  It is possible that duplicate targets were created.
sync_from_gomod: go_mod_download go_mod_tidy go_mod_vendor go_mod_verify gazelle_update_repos gazelle_generate_repos

unit_test:
	$(BZLCMD) test --test_output=all --test_verbose_timeout_warnings "//cmd:cmd_test"

#tidy:
#	@rm -rf vendor
#	go mod tidy
#	go mod vendor -v
#
#zap:
#	@rm go.sum
#	@rm -rf vendor
#	go clean -modcache
#	go mod download
#	go mod tidy
#	go mod vendor -v