#!/usr/bin/env bash
# Exit immediately if any command including those in a piped sequence exits with a non-zero status
set -euo pipefail

echo "Updating version in ${PROJECT_FILE} to ${VERSION}"

# Update existing Version tag if it exists, otherwise add a new PropertyGroup and Version
if grep -q "<Version>" "${PROJECT_FILE}"; then
    sed -i "s#<Version>.*</Version>#<Version>${VERSION}</Version>#" "${PROJECT_FILE}"
else
    # Insert a PropertyGroup with Version right before the closing Project tag
    sed -i 's#</Project>#  <PropertyGroup>\n    <Version>'"${VERSION}"'</Version>\n  </PropertyGroup>\n</Project>#' "${PROJECT_FILE}"
fi

dotnet pack

dotnet nuget push ./bin/Release/*.nupkg --source "${PACKAGE_REPOSITORY}" --api-key "${NUGET_TOKEN}"
