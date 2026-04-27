variable "REGISTRY" {
  default = "ghcr.io/wiremind"
}

variable "SPOA_VERSIONS" {
  default = [
    "0.3.0", # renovate: datasource=docker depName=ghcr.io/crowdsecurity/spoa-bouncer
  ]
}

group "default" {
  targets = ["spoa"]
}

target "spoa" {
  name       = "spoa-${replace(v, ".", "-")}"
  matrix     = { v = SPOA_VERSIONS }
  context    = "."
  dockerfile = "Containerfile"
  tags       = ["${REGISTRY}/cs-haproxy-spoa-bouncer:${v}"]
  args       = {
    GEOLITE_VERSION = "2026.04.25",
    SPOA_BOUNCER_VERSION = "${v}",
  }
  platforms  = ["linux/amd64", "linux/arm64"]
}
