FROM mcr.microsoft.com/dotnet/sdk:9.0.308-noble-amd64

ENTRYPOINT ["/bin/bash", "-c", "mkdir -p /logs && echo \"CUSTOM_DEVCONTAINER: dotnet9-workflow-test-container\" > /logs/devcontainer.log && exec \"$@\"", "--"]
