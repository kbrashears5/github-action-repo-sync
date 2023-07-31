<h1 align="center">github-action-repo-sync</h1>

<div align="center">
    
<b>Github Action to sync repo metadata from code to repo</b>

[![Build Status](https://dev.azure.com/kbrashears5/github/_apis/build/status/kbrashears5.github-action-repo-sync?branchName=master)](https://dev.azure.com/kbrashears5/github/_build/latest?definitionId=27&branchName=master)

</div>

# Use Cases
Keep the github metadata in sync with your code! Metadata is now configuration as code, and can be validated with a Pull Request.

# Setup
Create a new file called `/.github/workflows/repo-sync.yml` that looks like so:
```yaml
name: Repo Sync

on:
  push:
    branches:
      - master
  schedule:
    - cron: 0 0 * * *

jobs:
  repo_sync:
    runs-on: ubuntu-latest
    steps:
      - name: Fetching Local Repository
        uses: actions/checkout@master
      - name: Repo Sync
        uses: kbrashears5/github-action-repo-sync@v1.0.0
        with:
          TYPE: npm
          PATH: package.json
          TOKEN: ${{ secrets.GH_PERSONAL_TOKEN }}
```

Note that the built in `secrets.github_token` does not have the necessary permissions to update the repo description. Use
a personal access token instead:

```shell
gh secret set GH_PERSONAL_TOKEN --app actions --body ghp_the_key
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
