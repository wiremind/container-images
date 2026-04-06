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
    BASE = "gcr.io/distroless/base-debian13:nonroot@sha256:a696c7c8545ba9b2b2807ee60b8538d049622f0addd85aee8cec3ec1910de1f9"
    DEBIAN_SNAPSHOT_VERSION = "${DEBIAN_SNAPSHOT_VERSION}",
    HAPROXY_VERSION = v,
  }
  platforms  = ["linux/amd64", "linux/arm64"]
}
