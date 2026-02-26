variable "REGISTRY" {
  default = "ghcr.io/wiremind"
}

// Bump this version when changing the image (extensions, config, etc.)
// - minor: new extensions or features
// - patch: bug fixes, security updates, dependency bumps
variable "IMAGE_VERSION" {
  default = "1.0.0"
}

variable "PG_MAJOR_VERSIONS" {
  default = ["16", "17"]
}

group "default" {
  targets = ["debian13"]
}

target "debian13" {
  name       = "debian13-pg${v}"
  matrix     = { v = PG_MAJOR_VERSIONS }
  context    = "."
  dockerfile = "Containerfile"
  tags       = [
    "${REGISTRY}/cnpg-spilo-postgres:${v}-${IMAGE_VERSION}-debian13",
    "${REGISTRY}/cnpg-spilo-postgres:${v}-debian13",
  ]
  args       = {
    UPSTREAM_TAG = "${v}-standard-trixie"
    PG_MAJOR     = v
  }
  platforms  = ["linux/amd64"]
}
