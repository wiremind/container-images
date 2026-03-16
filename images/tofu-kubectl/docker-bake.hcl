variable "REGISTRY" {
  default = "ghcr.io/wiremind"
}

// tofu version to install (see https://github.com/opentofu/opentofu/releases/)
variable "TOFU_VERSION" {
  default = "1.11.5"
}

// kubectl versions to bundle alongside tofu
variable "KUBECTL_VERSIONS" {
  default = ["v1.33.0"]
}

group "default" {
  targets = ["debian13"]
}

target "debian13" {
  name       = "debian13-${replace(replace(k, ".", "-"), "v", "")}"
  matrix     = { k = KUBECTL_VERSIONS }
  context    = "."
  dockerfile = "Containerfile.debian13"
  tags       = ["${REGISTRY}/tofu-kubectl:${TOFU_VERSION}-${k}-debian13"]
  args       = { TOFU_VERSION = TOFU_VERSION, KUBECTL_VERSION = k }
  platforms  = ["linux/amd64"]
}
