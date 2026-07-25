FROM mcr.microsoft.com/dotnet/sdk:10.0.302-noble-amd64@sha256:3dae2f7699441af56216ff64d5c9b6dfce7cd7dc7f4f71d353d29662b10a384f

ENTRYPOINT ["/bin/bash", "-c", "mkdir -p /logs && echo \"CUSTOM_DEVCONTAINER: dotnet10-workflow-test-container\" > /logs/devcontainer.log && exec \"$@\"", "--"]
