variable "REGISTRY" {
  default = "ghcr.io/wiremind"
}

// BusyBox versions used across targets (e.g., "1.34.1", "1.35.0")
variable "BB_VERSIONS" {
  default = [
    "1.37.0",  # renovate: datasource=docker depName=docker.io/library/busybox
  ]
}

group "default" {
  targets = ["debian13-hardened"]
}

target "debian13-hardened" {
  name       = "debian13-hardened-${replace(v, ".", "-")}"
  matrix     = { v = BB_VERSIONS }
  context    = "."
  dockerfile = "Containerfile.debian13-hardened"
  tags       = ["${REGISTRY}/busybox:${v}-debian13-hardened"]
  args       = { UPSTREAM_TAG = "${v}-debian13" }
  platforms  = ["linux/amd64"]
}
