#!/bin/bash
# Prepare test environment for a workflow test
# Usage: prepare-test-environment.sh <test-name> <project-dir>
# Example: prepare-test-environment.sh dotnet8-workflow-test TestDotnet8

set -e

TEST_NAME="$1"
PROJECT_DIR="$2"

if [ -z "$TEST_NAME" ] || [ -z "$PROJECT_DIR" ]; then
    echo "Error: test name and project directory required"
    echo "Usage: prepare-test-environment.sh <test-name> <project-dir>"
    exit 1
fi

mkdir -p "${GITHUB_WORKSPACE}/tests/${TEST_NAME}/logs"

# Back up existing .devcontainer and NuGet.Config
if [ -d "${GITHUB_WORKSPACE}/.devcontainer" ]; then
    mv "${GITHUB_WORKSPACE}/.devcontainer" "${GITHUB_WORKSPACE}/.devcontainer.bak"
fi
if [ -f "${GITHUB_WORKSPACE}/NuGet.Config" ]; then
    mv "${GITHUB_WORKSPACE}/NuGet.Config" "${GITHUB_WORKSPACE}/NuGet.Config.bak"
fi

# Copy our test .devcontainer to the root
cp -r "${GITHUB_WORKSPACE}/tests/${TEST_NAME}/.devcontainer" "${GITHUB_WORKSPACE}/"

# Copy test NuGet.Config to workspace root to allow insecure HTTP for testing
cp "${GITHUB_WORKSPACE}/tests/${TEST_NAME}/${PROJECT_DIR}/NuGet.Config" "${GITHUB_WORKSPACE}/NuGet.Config"

# Create and push test container image
docker build -t localhost:5000/${TEST_NAME}-devcontainer:latest \
    -f ${GITHUB_WORKSPACE}/tests/${TEST_NAME}/devcontainer-to-publish/Dockerfile \
    ${GITHUB_WORKSPACE}/tests/${TEST_NAME}/devcontainer-to-publish/

docker login localhost:5000 -u testuser -p testpassword
docker push localhost:5000/${TEST_NAME}-devcontainer:latest
