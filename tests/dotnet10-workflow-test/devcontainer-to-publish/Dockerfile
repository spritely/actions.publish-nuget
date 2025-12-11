FROM mcr.microsoft.com/dotnet/sdk:10.0.101-noble-amd64

ENTRYPOINT ["/bin/bash", "-c", "mkdir -p /logs && echo \"CUSTOM_DEVCONTAINER: dotnet10-workflow-test-container\" > /logs/devcontainer.log && exec \"$@\"", "--"]
