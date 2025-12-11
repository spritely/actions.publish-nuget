#!/bin/bash
# Assert that NuGet package was published
# Usage: assert-nuget-published.sh <package-name>
# Example: assert-nuget-published.sh testdotnet8

set -e

PACKAGE_NAME="$1"

if [ -z "$PACKAGE_NAME" ]; then
    echo "Error: package name required"
    echo "Usage: assert-nuget-published.sh <package-name>"
    exit 1
fi

source ${GITHUB_WORKSPACE}/tests/test-reporter.sh
set_test_name "Assert NuGet package was published"

# Query the NuGet server API to check if the package exists
response=$(curl -s "http://localhost:5001/v3/registration/${PACKAGE_NAME}/1.0.0.json" -o /dev/null -w "%{http_code}")

if [ "$response" -eq 200 ]; then
    success "NuGet package was published successfully"
else
    failure "NuGet package was not found on the server (HTTP $response)"

    # Try to get package list for debugging
    echo "Search results for '${PACKAGE_NAME}':"
    curl -s "http://localhost:5001/v3/search?q=${PACKAGE_NAME}"
fi
