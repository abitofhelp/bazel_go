# bazel_go

This repository contains a Go application that can be built using 'go build' or Bazel.


The targets can be built using 'go build' or Bazel.
The source of truth for dependencies is the go.mod file.
The Makefile contains many queries and commands for using the Go's native tooling and Bazel commands.

## Valid Bazel Labels
* //:gazelle
* //:gazelle-runner
* //cmd:cmd
* //cmd:cmd_lib
* //cmd:cmd_test
* //cmd:gazelle
* //cmd:gazelle-runner
* //cmd/vendor/github.com/davecgh/go-spew/spew:spew
* //cmd/vendor/github.com/pmezard/go-difflib/difflib:difflib
* //cmd/vendor/github.com/stretchr/testify/assert:assert
* //cmd/vendor/gopkg.in/yaml.v3:yaml_v3

## To Change Go's Version
Execute the set_golang_version command in the Makefile.
