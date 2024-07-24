tag := "gha-rc1"

# Build the Docker image
build:
  docker build --tag restyled/restyler:{{tag}} .

test-pr := "restyled-io/demo#45"

# Test the Docker image against a demo PR
test: build
  docker run --rm \
    --env LOG_FORMAT=tty \
    --env LOG_LEVEL=debug \
    --env GITHUB_ACCESS_TOKEN \
    --volume /tmp:/tmp \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    restyled/restyler:{{tag}} --job-url https://example.com {{test-pr}}
