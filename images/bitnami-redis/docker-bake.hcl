variable "REGISTRY" {
  default = "ghcr.io/wiremind"
}

variable "REDIS_TAG" {
  default = "8.10.1-debian-12-r0"
}

group "default" {
  targets = ["redis", "redis-sentinel"]
}

target "redis" {
  context   = "redis"
  tags      = ["${REGISTRY}/bitnami/redis:${REDIS_TAG}"]
  platforms = ["linux/amd64"]
}

target "redis-sentinel" {
  context   = "redis-sentinel"
  tags      = ["${REGISTRY}/bitnami/redis-sentinel:${REDIS_TAG}"]
  platforms = ["linux/amd64"]
}
