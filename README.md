# github-action-repo-sync
Github Action to sync repo metadata from code to repo

[![Repo Metadata Sync](https://github.com/kbrashears5/github-action-repo-sync/actions/workflows/repo-metadata-sync.yml/badge.svg)](https://github.com/kbrashears5/github-action-repo-sync/actions/workflows/repo-metadata-sync.yml)

# Use Cases
Keep the github metadata in sync with your code! Metadata is now configuration as code, and can be validated with a Pull Request.

# Setup
Create a new file called `/.github/workflows/repo-sync.yml` that looks like so:
```yaml
name: Repo Sync

on:
  push:
    branches:
      - main
  schedule:
    - cron: 0 0 * * *

jobs:
  repo_sync:
    runs-on: ubuntu-latest
    steps:
      - name: Fetching Local Repository
        uses: actions/checkout@v3
      - name: Repo Metadata Sync
        uses: kbrashears5/github-action-repo-sync@v2.0.0
        with:
          TYPE: npm
          PATH: package.json
          TOKEN: ${{ secrets.ACTIONS }}
```
## Parameters
| Parameter | Required | Description |
| --- | --- | --- |
| TYPE | true | Type of repo. See below for supported repo types |
| PATH | true | Path to the repo type's metadata file |
| TOKEN | true | Personal Access Token with Repo scope |

## Supported Repo Types
| Repo Type | File | Description |
| --- | --- | --- |
| npm | package.json | package.json for repo |
| nuget | ProjectName.csproj | csproj file for project |
| python | ProjectName.toml | toml file for project |

## Tips
For repo types that aren't listed above (like this one), you can still use this action, just have to get creative.

For example (and I would recommend), you can create a file called `metadata.json`, choose the npm type, and make the file look like so:
```json
{
  "description": "Repo description",
  "homepage": "https://github.com/kbrashears5/github-action-repo-sync",
  "keywords": [
    "sync",
    "repo",
    "metadata"
  ]
}
```
For example, see `.github/workflows/repo-sync.yml` & `metadata.json` in this repo
