variable "REGISTRY" {
  default = "ghcr.io/wiremind"
}

// HAProxy versions used across targets (e.g., "2.8.18", "3.0.14")
variable "HAPROXY_VERSIONS" {
  default = [
    "2.8.20", # renovate: datasource=docker depName=docker.io/library/haproxy
    "3.0.19", # renovate: datasource=docker depName=docker.io/library/haproxy
    "3.2.15", # renovate: datasource=docker depName=docker.io/library/haproxy
    "3.3.6",  # renovate: datasource=docker depName=docker.io/library/haproxy
  ]
}

group "default" {
  targets = ["debian13", "debian13-hardened"]
}

target "debian13" {
  name       = "debian13-${replace(v, ".", "-")}"
  matrix     = { v = HAPROXY_VERSIONS }
  context    = "."
  dockerfile = "Containerfile.debian13"
  tags       = ["${REGISTRY}/haproxy:${v}-debian13"]
  args       = { UPSTREAM_TAG = "${v}-trixie" }
  platforms  = ["linux/amd64", "linux/arm64"]
}

target "debian13-hardened" {
  name       = "debian13-hardened-${replace(v, ".", "-")}"
  matrix     = { v = HAPROXY_VERSIONS }
  context    = "."
  dockerfile = "Containerfile.debian13-hardened"
  tags       = ["${REGISTRY}/haproxy:${v}-debian13-hardened"]
  args       = {
    UPSTREAM_TAG = "${v}-debian13",
    DEBIAN_SNAPSHOT_VERSION = "20260405T082808Z",
  }
  platforms  = ["linux/amd64", "linux/arm64"]
}
