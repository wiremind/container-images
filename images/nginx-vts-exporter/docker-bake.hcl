variable "REGISTRY" {
  default = "ghcr.io/wiremind"
}

// Latest nginx stable branch (even minor version). The build appends "-alpine" to select the Alpine variant.
variable "NGINX_VERSION" {
  default = "1.30.5" # renovate: datasource=docker depName=docker.io/nginxinc/nginx-unprivileged
}

group "default" {
  targets = ["nginx-vts-exporter"]
}

target "nginx-vts-exporter" {
  context    = "."
  dockerfile = "Containerfile"
  tags       = ["${REGISTRY}/nginx-vts-exporter:${NGINX_VERSION}-alpine"]
  args       = { UPSTREAM_TAG = "${NGINX_VERSION}-alpine" }
  platforms  = ["linux/amd64", "linux/arm64"]
}
