#!/bin/bash
# Clean up test environment
# Usage: cleanup-test-environment.sh

set -e

# Restore original .devcontainer and NuGet.Config
rm -rf "${GITHUB_WORKSPACE}/.devcontainer"
if [ -d "${GITHUB_WORKSPACE}/.devcontainer.bak" ]; then
    mv "${GITHUB_WORKSPACE}/.devcontainer.bak" "${GITHUB_WORKSPACE}/.devcontainer"
fi
rm -f "${GITHUB_WORKSPACE}/NuGet.Config"
if [ -f "${GITHUB_WORKSPACE}/NuGet.Config.bak" ]; then
    mv "${GITHUB_WORKSPACE}/NuGet.Config.bak" "${GITHUB_WORKSPACE}/NuGet.Config"
fi
