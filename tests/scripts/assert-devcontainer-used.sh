#!/bin/bash
# Assert that custom devcontainer was used
# Usage: assert-devcontainer-used.sh <test-name>
# Example: assert-devcontainer-used.sh dotnet8-workflow-test

set -e

TEST_NAME="$1"

if [ -z "$TEST_NAME" ]; then
    echo "Error: test name required"
    echo "Usage: assert-devcontainer-used.sh <test-name>"
    exit 1
fi

source ${GITHUB_WORKSPACE}/tests/test-reporter.sh
set_test_name "Assert custom devcontainer was used"

log_file="${GITHUB_WORKSPACE}/tests/${TEST_NAME}/logs/devcontainer.log"

if [ -f "$log_file" ]; then
    if grep -q "CUSTOM_DEVCONTAINER: ${TEST_NAME}-container" "$log_file"; then
        success "Custom devcontainer was used"
    else
        failure "Custom devcontainer marker not found in logs"
    fi
    cat "$log_file"
else
    failure "Devcontainer log file not found"
    ls -la "${GITHUB_WORKSPACE}/tests/${TEST_NAME}/logs/"
fi
