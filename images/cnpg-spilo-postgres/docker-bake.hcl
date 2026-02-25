variable "REGISTRY" {
  default = "ghcr.io/wiremind"
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
  tags       = ["${REGISTRY}/cnpg-spilo-postgres:${v}-debian13"]
  args       = {
    UPSTREAM_TAG = "${v}-standard-trixie"
    PG_MAJOR     = v
  }
  platforms  = ["linux/amd64"]
}
