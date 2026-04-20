variable "REGISTRY" {
  default = "ghcr.io/wiremind"
}

# See: https://github.com/docker/buildx
variable "BUILDX_VERSIONS" {
  default = ["v0.32.1", "v0.33.0"]
}

# Use fixed Debian snapshot version to ensure reproducible builds (see https://snapshot.debian.org/)
variable "DEBIAN_SNAPSHOT_VERSION" {
  default = "20260406T144517Z"
}

group "default" {
  targets = ["debian13"]
}

target "debian13" {
  name       = "debian13-${replace(v, ".", "-")}"
  matrix     = { v = BUILDX_VERSIONS }
  context    = "."
  dockerfile = "Containerfile.debian13"
  tags       = ["${REGISTRY}/buildx:${v}-debian13"]
  args       = {
    DEBIAN_SNAPSHOT_VERSION = "${DEBIAN_SNAPSHOT_VERSION}",
    BUILDX_VERSION = "${v}",
  }
  platforms  = ["linux/amd64", "linux/arm64"]
}
