set dotenv-load

[private]
_docker := require("docker")

_default:
    @{{ just_executable() }} --list

_docker_build TARGET:
    docker build -t blog-{{ TARGET }} --target {{ TARGET }} .

_build-builder: (_docker_build "builder")

_build-watcher: (_docker_build "watcher")

# Builds the blog
build: _build-builder
    docker run --rm --name blog-build -it \
      -v {{ justfile_directory() }}:/blog \
      blog-builder -b johnnyasantos.com

# Serves the blog on port 8080 and 8081
watch: _build-watcher
    docker run --rm --name blog-watch -it \
      -v {{ justfile_directory() }}:/blog \
      -p 8080:8080 \
      -p 8081:8081 \
      blog-watcher

# Opens a shell in the watcher container
shell:
    docker exec -it blog-watch /bin/bash

# Generates favicon from profile image
gen-favicon:
    sips -z 32 32 assets/imgs/myself_circle.png --out assets/favicon.ico

lint:
    npx -y markdownlint-cli2@0.23.2 \
        --config .config/markdownlint.json \
        _presentations/ \
        _posts/ \
        "!./**/wip*"
