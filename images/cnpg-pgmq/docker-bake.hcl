variable "REGISTRY" {
  default = "ghcr.io/wiremind"
}

// Bump this version when the image content changes (extensions, packages).
// - minor: a new extension
// - patch: a bug fix, a security update, a dependency bump
variable "IMAGE_VERSION" {
  default = "1.0.0"
}

variable "PG_MAJOR_VERSIONS" {
  default = ["17", "18"]
}

// Base image tag per PostgreSQL major. Keep these equal to CNPG_STANDARD_IMAGES
// in overwhelm (src/overwhelm/config.py), which the deployed CNPG operator supports.
variable "UPSTREAM_TAGS" {
  default = {
    "17" = "17.6-system-trixie" # renovate: datasource=docker depName=ghcr.io/cloudnative-pg/postgresql
    "18" = "18.0-system-trixie" # renovate: datasource=docker depName=ghcr.io/cloudnative-pg/postgresql
  }
}

// pg_partman Debian package version per PostgreSQL major. PostgreSQL 17 takes
// 5.2.4-1 from Debian trixie, which matches the Patroni source. PostgreSQL 18
// takes 5.5.0 from PGDG, because Debian trixie packages pg_partman for 17 only.
variable "PARTMAN_VERSIONS" {
  default = {
    "17" = "5.2.4-1"
    "18" = "5.5.0-1.pgdg13+1"
  }
}

// pgmq extension release (see https://github.com/pgmq/pgmq/releases)
variable "PGMQ_VERSION" {
  default = "1.11.1" # renovate: datasource=github-releases depName=pgmq/pgmq
}

// sha256 of https://github.com/pgmq/pgmq/archive/refs/tags/v${PGMQ_VERSION}.tar.gz
variable "PGMQ_SHA256" {
  default = "8d2d81ec7bf4d1efaeabe1363063f1ec8ab839f1dd2fd94ab901e4507dacb4b8"
}

# Use fixed Debian snapshot version to ensure reproducible builds (see https://snapshot.debian.org/)
variable "DEBIAN_SNAPSHOT_VERSION" {
  default = "20260406T144517Z"
}

group "default" {
  targets = ["debian13"]
}

target "debian13" {
  name       = "debian13-pg${v}"
  matrix     = { v = PG_MAJOR_VERSIONS }
  context    = "."
  dockerfile = "Containerfile.debian13"
  tags = [
    // The ImageCatalog in overwhelm references this immutable tag.
    "${REGISTRY}/cnpg-pgmq:${split("-", UPSTREAM_TAGS[v])[0]}-${IMAGE_VERSION}-debian13",
    "${REGISTRY}/cnpg-pgmq:${v}-debian13",
  ]
  args = {
    UPSTREAM_TAG            = UPSTREAM_TAGS[v],
    PG_MAJOR                = v,
    PARTMAN_VERSION         = PARTMAN_VERSIONS[v],
    PGMQ_VERSION            = "${PGMQ_VERSION}",
    PGMQ_SHA256             = "${PGMQ_SHA256}",
    DEBIAN_SNAPSHOT_VERSION = "${DEBIAN_SNAPSHOT_VERSION}",
  }
  platforms = ["linux/amd64"]
}
