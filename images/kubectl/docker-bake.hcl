variable "REGISTRY" {
  default = "ghcr.io/wiremind"
}

# Use fixed Debian snapshot version to ensure reproducible builds (see https://snapshot.debian.org/)
variable "DEBIAN_SNAPSHOT_VERSION" {
  default = "20260409T082340Z"
}

// kubectl versions (e.g., "v1.34.3", "v1.35.0")
variable "DEBIAN_VERSIONS" {
  default = [
    "v1.34.6",
    "v1.35.3"
  ]
}

group "default" {
  targets = ["debian13"]
}

target "debian13" {
  name       = "debian13-${replace(replace(v, ".", "-"), "v", "")}"
  matrix     = { v = DEBIAN_VERSIONS }
  context    = "."
  dockerfile = "Containerfile.debian13"
  tags       = ["${REGISTRY}/kubectl:${v}-debian13"]
  args       = {
    DEBIAN_SNAPSHOT_VERSION = "${DEBIAN_SNAPSHOT_VERSION}"
    UPSTREAM_TAG            = v
  }
  platforms  = ["linux/amd64", "linux/arm64"]
}
