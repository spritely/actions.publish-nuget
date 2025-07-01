# actions.publish-nuget

Packs and publishes NuGet packages to a package registry in a repo that uses dotnet devcontainers.

## Features

- 🐋 Devcontainer-based builds for environment consistency
- 📦 Automated NuGet packaging/publishing

## Usage Examples

### Minimal example that publishes to GitHub package registry

```yaml
name: Publish Package
on: [push]

permissions:
    packages: write # So github.token can publish NuGet packages

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: spritely/actions.publish-nuget@v0.1.1
        with:
          nugetAuthToken: ${{ github.token }}
          projectFile: MyProject/MyProject.csproj
          version: 1.0.0
          # This is the default, but you can publish to other private registries
          # Just make sure to provide the correct nugetAuthToken
          # packageRepository: https://nuget.pkg.github.com/your-org/index.json
```

### Building with devcontainer from private GitHub container registry

```yaml
name: Publish from Private Registry
on: [workflow_dispatch]

permissions:
    packages: write

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: spritely/actions.publish-nuget@v0.1.1
        with:
          nugetAuthToken: ${{ github.token }}
          projectFile: MyPackage/MyPackage.csproj
          version: 2.1.0-rc.1
          # Read devcontainers from here
          registryHost: ghcr.io
          registryUsername: ${{ github.actor }}
          registryPassword: ${{ github.token }}
```

## Inputs

| Parameter | Description | Required | Default |
|-----------|-------------|----------|---------|
| `nugetAuthToken` | NuGet authentication token | Yes | - |
| `projectFile` | Path to .csproj file (relative to root) | Yes | - |
| `version` | Full SemVer 2.0 version string | Yes | - |
| `packageRepository` | NuGet feed URL | No | GitHub Packages URL |
| `registryHost` | Container registry host for fetching devcontainer | No | - |
| `registryUsername` | Container registry auth username | No | - |
| `registryPassword` | Container registry auth token | No | - |

## Testing Strategy

### 1. Unit tests (`publish-nuget.bats`)

Validate core script logic locally in isolation using a local filesystem based NuGet server.

### 2. Workflow tests (`workflow-test/`)

Verify full GitHub Action behavior using test container registries and NuGet servers. Runs only in GitHub Action pipeline for testing overall workflow.

## DevContainer Decision

This action requires that each repository setup a DevContainer. This is more complex than just having dotnet available on the build server and running the packaging and publishing directory.

This decision is intentional to steer development to adopt DevContainers across all repositories, establishing a unified development approach and obtaining key DevContainer benefits including:

1. Zero-config onboarding
   - New contributors get working environment with:
     1. git clone
     2. Open project
     3. "Reopen in Container"

2. Consistency
   - Identical build environments for development and build server pipelines
   - Reduces "works on my machine" issues
   - Container-based workflows are more easily portable to alternative platforms like Dagger, GitLab, or Gitea.

3. Dependency management
   - Precise control over build tools, dependencies, and runtime versions without relying on GitHub runner configurations.

4. Multi-OS Support
   - Develop Linux-targeted software from Windows/macOS hosts

While this approach requires explicit DevContainer configuration in each repository, we believe the consistency and reliability benefits outweigh the initial setup cost. Repositories without DevContainers will need to either implement them or develop alternative packaging solutions.

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](/LICENSE) file for details.

