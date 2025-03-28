#!/usr/bin/env bats

setup() {
    # Create a temporary directory for each test
    export TEMP_DIR="$(mktemp -d)"
    export SCRIPT_PATH="${BATS_TEST_DIRNAME}/../publish-nuget.sh"
    
    # Setup local NuGet feed
    export LOCAL_NUGET_FEED="${TEMP_DIR}/nuget-feed"
    mkdir -p "${LOCAL_NUGET_FEED}"
    
    create_project() {
        local project_name="${1:-TestProject}"
        local root_path="${2:-${TEMP_DIR}}"
        
        mkdir -p "${root_path}"
        cd "${root_path}"
        dotnet new classlib -n "${project_name}" --force > /dev/null
        
        echo "${root_path}/${project_name}/${project_name}.csproj"
    }

    run_script() {
        export PROJECT_FILE="$1"
        export VERSION="${2:-1.0.0}"
        export PACKAGE_REPOSITORY="file://${LOCAL_NUGET_FEED}/"
        export NUGET_TOKEN="fake-token"

        run bash "${SCRIPT_PATH}"
    }

    assert_package_created() {
        local project_file="$1"
        local version="${2:-1.0.0}"
        local project_dir="$(dirname "${project_file}")"
        local project_name="$(basename "${project_file}" .csproj)"
        local package_name="${3:-${project_name}.${version}.nupkg}"
        
        # Verify version in csproj
        grep -q "<Version>${version}</Version>" "${project_file}"
        
        # Verify package created
        [ -f "${project_dir}/bin/Release/${package_name}" ]
        
        # Verify package pushed to feed
        [ -f "${LOCAL_NUGET_FEED}/${package_name}" ]
    }
}

teardown() {
    rm -rf "${TEMP_DIR}"
}

teardown_file() {
    # The .NET SDK keeps a background build server (VBCSCompiler) running to speed up subsequent builds.
    # This process isn't automatically terminated after the script runs.
    # When you source the script in Bats, any child processes become subprocesses of the Bats test runner.
    # Bats waits for all subprocesses to exit before completing and thus the last test hangs and never exits.
    # "dotnet build-server shutdown" gracefully terminates the Razor build server, the VB/C# compiler server,
    # and the MSBuild server.
    dotnet build-server shutdown
}

@test "publish-nuget fails when project file doesn't exist" {
    # Act
    cd "${TEMP_DIR}"
    run_script "NonExistentProject.csproj" "1.0.0"
    
    # Assert script fails
    [ "$status" -ne 0 ]
    [[ "$output" == *"not found"* ]]
}

@test "publish-nuget adds Version tag if none exists" {
    # Arrange
    local project_file=$(create_project)
    local version="1.2.3"

    # Act
    run_script "$project_file" "$version"
    
    # Assert
    assert_package_created "$project_file" "$version"
}

@test "publish-nuget updates existing Version tag" {
    # Arrange
    local project_file=$(create_project)
    local version="3.0.0"

    # Insert initial version number in file
    sed -i 's#<PropertyGroup>#<PropertyGroup>\n    <Version>1.0.0-local</Version>#' "$project_file"
    
    # Act
    run_script "$project_file" "$version"
    
    # Assert
    assert_package_created "$project_file" "$version"
}

@test "publish-nuget handles complex semantic versions" {
    # Arrange
    local project_file=$(create_project)
    local version="1.0.0-beta.1+build.123"

    # Act
    run_script "$project_file" "$version"
    
    # Assert
    # NuGet converts '+' in SemVer to '.' in filenames for filesystem compatibility and could vary between environments
    # We have a well-known C# version from the devcontainer so we don't need to check for all the possible cases
    # The version in the csproj remains "1.0.0-beta.1+build.123" but the package filename becomes "TestProject.1.0.0-beta.1"
    local project_name="$(basename "${project_file}" .csproj)"
    local package_name="${project_name}.1.0.0-beta.1.nupkg"
    # The last parameter here overrides the default package name which would use the full version number by default
    assert_package_created "$project_file" "1.0.0-beta.1+build.123" "${package_name}"
}

@test "publish-nuget handles project file in subdirectory" {
    # Arrange
    # Create nested project
    local project_file=$(create_project "SubdirLib" "${TEMP_DIR}/nested")
    local version="1.5.0"
    
    # Act
    run_script "$project_file" "$version"

    # Assert
    assert_package_created "$project_file" "$version"
}

@test "publish-nuget handles absolute path to project file" {
    # Arrange
    local project_file=$(create_project "AbsoluteLib" "${TEMP_DIR}/absolute")
    local version="2.0.0"

    # Run from different directory with absolute path
    cd /src
    run_script "$project_file" "$version"

    assert_package_created "$project_file" "$version"
}
