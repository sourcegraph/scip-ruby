# Build from the base image (local, not published)
ARG BASE_TAG
FROM scip-ruby-base:${BASE_TAG}

# This Docker image provides scip-ruby for CI/CD pipelines

# Default command is to run scip-ruby
CMD ["scip-ruby"]
