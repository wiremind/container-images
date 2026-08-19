variable "REGISTRY" {
  default = "ghcr.io/wiremind"
}

// HAProxy versions used across targets (e.g., "2.8.18", "3.0.14"), only build LTS versions
variable "HAPROXY_VERSIONS" {
  default = [
    "2.8.27", # renovate: datasource=docker depName=docker.io/library/haproxy
    "3.0.22", # renovate: datasource=docker depName=docker.io/library/haproxy
    "3.2.18", # renovate: datasource=docker depName=docker.io/library/haproxy
  ]
}

# Use fixed Debian snapshot version to ensure reproducible builds (see https://snapshot.debian.org/)
variable "DEBIAN_SNAPSHOT_VERSION" {
  default = "20260406T144517Z"
}

group "default" {
  targets = ["debian13", "debian13-dhi", "debian13-gcr"]
}

target "debian13" {
  name       = "debian13-${replace(v, ".", "-")}"
  matrix     = { v = HAPROXY_VERSIONS }
  context    = "."
  dockerfile = "Containerfile.debian13"
  tags       = ["${REGISTRY}/haproxy:${v}-debian13"]
  args       = {
    DEBIAN_SNAPSHOT_VERSION = "${DEBIAN_SNAPSHOT_VERSION}",
    UPSTREAM_TAG = "${v}-trixie",
  }
  platforms  = ["linux/amd64", "linux/arm64"]
}

target "debian13-dhi" {
  name       = "debian13-dhi-${replace(v, ".", "-")}"
  matrix     = { v = HAPROXY_VERSIONS }
  context    = "."
  dockerfile = "Containerfile.debian13-dhi"
  tags       = ["${REGISTRY}/haproxy:${v}-debian13-dhi"]
  args       = {
    DEBIAN_SNAPSHOT_VERSION = "${DEBIAN_SNAPSHOT_VERSION}",
    UPSTREAM_TAG = "${v}-debian13",
  }
  platforms  = ["linux/amd64", "linux/arm64"]
}

target "debian13-gcr" {
  name       = "debian13-gcr-${replace(v, ".", "-")}"
  matrix     = { v = HAPROXY_VERSIONS }
  context    = "."
  dockerfile = "Containerfile.debian13-gcr"
  tags       = ["${REGISTRY}/haproxy:${v}-debian13-gcr"]
  args       = {
    BASE = "gcr.io/distroless/base-debian13:nonroot@sha256:fb282f8ed3057f71dbfe3ea0f5fa7e961415dafe4761c23948a9d4628c6166fe"
    DEBIAN_SNAPSHOT_VERSION = "${DEBIAN_SNAPSHOT_VERSION}",
    HAPROXY_VERSION = v,
  }
  platforms  = ["linux/amd64", "linux/arm64"]
}
