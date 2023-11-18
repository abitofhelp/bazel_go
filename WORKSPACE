## WORKSPACE

workspace(name = "bazel_go")

## VERSIONS
BAZEL_GAZELLE_VERSION = "0.34.0"

GO_VERSION = "1.21.3"

RULES_GO_VERSION = "0.42.0"

RUST_VERSIONS = [
    "1.73.0",
    "nightly/2023-11-12",
]

RULES_RUST_VERSION = "0.30.0"

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

## RULES_GO AND GAZELLE ###################################################################################
## RULES_GO
http_archive(
    name = "io_bazel_rules_go",
    sha256 = "91585017debb61982f7054c9688857a2ad1fd823fc3f9cb05048b0025c47d023",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/{version}/rules_go-v{version}.zip".format(version = RULES_GO_VERSION),
        "https://github.com/bazelbuild/rules_go/releases/download/{version}/rules_go-v{version}.zip".format(version = RULES_GO_VERSION),
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "b7387f72efb59f876e4daae42f1d3912d0d45563eac7cb23d1de0b094ab588cf",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/{version}/bazel-gazelle-v{version}.tar.gz".format(version = BAZEL_GAZELLE_VERSION),
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/{version}/bazel-gazelle-v{version}.tar.gz".format(version = BAZEL_GAZELLE_VERSION),
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

############################################################
# Define your own dependencies here using go_repository.
# Else, dependencies declared by rules_go/gazelle will be used.
# The first declaration of an external repository "wins".
############################################################

## Load go_repositories here... ########################################################################################
load("//:go_deps.bzl", "go_dependencies")

# gazelle:repository_macro go_deps.bzl%go_dependencies
go_dependencies()
########################################################################################################################

go_rules_dependencies()
go_register_toolchains(version = "{version}".format(version = GO_VERSION))

gazelle_dependencies()

########################################################################################################################
