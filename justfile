image_tag := "gha-rc1"

# Build the Docker image
image:
  docker build --tag restyled/restyler:{{image_tag}} .

image-test: image
  docker run --rm \
    --env LOG_FORMAT=tty \
    --env LOG_LEVEL=debug \
    --env GITHUB_ACCESS_TOKEN \
    --volume /tmp:/tmp \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    restyled/restyler:{{image_tag}} \
      --job-url https://example.com \
      'restyled-io/demo#45'

# Push the Docker image
image-push: image
  docker push restyled/restyler:{{image_tag}}
