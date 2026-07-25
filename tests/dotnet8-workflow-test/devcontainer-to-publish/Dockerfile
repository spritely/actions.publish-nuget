FROM mcr.microsoft.com/dotnet/sdk:8.0.423-noble-amd64@sha256:21abeddfd86711de2db019e519f27f7b2ec63280b666dc92f14dddffa18c0803

ENTRYPOINT ["/bin/bash", "-c", "mkdir -p /logs && echo \"CUSTOM_DEVCONTAINER: dotnet8-workflow-test-container\" > /logs/devcontainer.log && exec \"$@\"", "--"]
