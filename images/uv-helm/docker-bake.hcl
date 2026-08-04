variable "REGISTRY" {
  default = "ghcr.io/wiremind"
}

// uv version (see https://github.com/astral-sh/uv/releases)
variable "UV_VERSION" {
  default = "0.11.6"
}

// helm version (see https://github.com/helm/helm/releases)
variable "HELM_VERSION" {
  default = "3.18.6"
}

// yq version (see https://github.com/mikefarah/yq/releases)
variable "YQ_VERSION" {
  default = "4.52.5"
}

group "default" {
  targets = ["debian13"]
}

target "debian13" {
  context    = "."
  dockerfile = "Containerfile.debian13"
  tags       = ["${REGISTRY}/uv-helm:${UV_VERSION}-helm${HELM_VERSION}-debian13"]
  args       = { UV_VERSION = UV_VERSION, HELM_VERSION = HELM_VERSION, YQ_VERSION = YQ_VERSION }
  platforms  = ["linux/amd64"]
}
