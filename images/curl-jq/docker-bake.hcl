variable "REGISTRY" {
  default = "ghcr.io/wiremind"
}

// curl versions (see https://hub.docker.com/r/curlimages/curl/tags)
variable "CURL_VERSION" {
  default = "8.20.0"  # renovate: datasource=docker depName=docker.io/curlimages/curl
}

// jq version (see https://pkgs.alpinelinux.org/packages?name=jq&branch=edge&repo=&arch=&origin=&flagged=&maintainer=)
variable "JQ_VERSION" {
  default = "1.8.1-r0"  # renovate: datasource=apk depName=jq
}

group "default" {
  targets = ["curl-jq"]
}

target "curl-jq" {
  context    = "."
  dockerfile = "Containerfile"
  tags       = ["${REGISTRY}/curl-jq:${CURL_VERSION}-jq${JQ_VERSION}"]
  args       = { CURL_VERSION = CURL_VERSION, JQ_VERSION = JQ_VERSION }
  platforms  = ["linux/amd64", "linux/arm64"]
}
