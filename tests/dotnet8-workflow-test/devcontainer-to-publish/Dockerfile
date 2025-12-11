FROM mcr.microsoft.com/dotnet/sdk:8.0.416-noble-amd64

ENTRYPOINT ["/bin/bash", "-c", "mkdir -p /logs && echo \"CUSTOM_DEVCONTAINER: dotnet8-workflow-test-container\" > /logs/devcontainer.log && exec \"$@\"", "--"]
