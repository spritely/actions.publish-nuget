FROM mcr.microsoft.com/dotnet/sdk:9.0.308-noble-amd64@sha256:84bca56e8fa1f9482563180b3d58e8038c333fb0c9fa466cc511ad03af5759c0

ENTRYPOINT ["/bin/bash", "-c", "mkdir -p /logs && echo \"CUSTOM_DEVCONTAINER: dotnet9-workflow-test-container\" > /logs/devcontainer.log && exec \"$@\"", "--"]
