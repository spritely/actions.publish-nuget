FROM mcr.microsoft.com/dotnet/sdk:9.0.301-noble-amd64

ENTRYPOINT ["/bin/bash", "-c", "mkdir -p /logs && echo \"CUSTOM_DEVCONTAINER: workflow-test-container\" > /logs/devcontainer.log && exec \"$@\"", "--"]
