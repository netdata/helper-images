# Docker images for CI system

Those images are used in our CI and build pipelines. They are not suitable for production usage.

### Image building

All images should be built with ["Automated Build"](https://docs.docker.com/docker-hub/builds/) system used by dockerhub and they should also use ["Repository Links"](https://docs.docker.com/docker-hub/builds/#repository-links) feature to force automatic upgrades when base image was updated.
