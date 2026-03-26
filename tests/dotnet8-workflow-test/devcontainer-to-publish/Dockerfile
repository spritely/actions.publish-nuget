FROM mcr.microsoft.com/dotnet/sdk:8.0.416-noble-amd64@sha256:f14e3d640c0ce3b8c32c3c231c86cbb707461ad88bb51a3f867bfd211312b3fa

ENTRYPOINT ["/bin/bash", "-c", "mkdir -p /logs && echo \"CUSTOM_DEVCONTAINER: dotnet8-workflow-test-container\" > /logs/devcontainer.log && exec \"$@\"", "--"]
