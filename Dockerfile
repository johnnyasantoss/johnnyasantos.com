FROM ruby:3.2-slim AS base

RUN apt-get update \
  && apt-get install -y --no-install-recommends --no-install-suggests \
  build-essential git

WORKDIR /blog
VOLUME /blog

COPY Gemfile Gemfile.lock ./
RUN bundle install

FROM base AS watcher

SHELL ["/bin/bash", "-c"]

ENV PORT=8080 \
  LR_PORT=8081
EXPOSE 8080 8081

ENTRYPOINT "exec" \
  bundle \
  exec \
  jekyll \
  serve \
  --host \
  0.0.0.0 \
  --port \
  "$PORT" \
  --watch \
  --drafts \
  --unpublished \
  --verbose \
  --trace \
  --livereload \
  --livereload-min-delay 1 \
  --livereload-port "$LR_PORT"

FROM base AS builder

ENTRYPOINT ["bundle", "exec", "jekyll", "build"]
CMD ["-h"]
