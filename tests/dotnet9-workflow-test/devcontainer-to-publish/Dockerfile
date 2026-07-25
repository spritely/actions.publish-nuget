FROM mcr.microsoft.com/dotnet/sdk:9.0.316-noble-amd64@sha256:959d4feb53839eb5171b95114407411e5f8b1534f9892c8e5124352d6df44bbd

ENTRYPOINT ["/bin/bash", "-c", "mkdir -p /logs && echo \"CUSTOM_DEVCONTAINER: dotnet9-workflow-test-container\" > /logs/devcontainer.log && exec \"$@\"", "--"]
