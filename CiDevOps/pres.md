---
title: CI/CD
author: Alexander Zerpa
aspectratio: 169
---
# GitHub Actions

## Workflows

`.github/workflows/<workflow>.yaml`

```yaml
name: <name>

on: [<event>]

jobs:
  <job>:
    runs-on: <runner>
    steps:
      - name: <step>
        uses: <action>
      - run: <cmd>
```

### On Events

::: columns
:::: column

#### Webhooks

```yaml
on:
  <event>:
    <event-filter>:
      - <filter>
```

::::
:::: column

#### Scheduled

```yaml
on:
  schedule:
    - cron: '* * * * *'
```

::::
:::

### Runners

- Ubuntu
- Windows
- macOS
- self-host

### Using Actions

::: columns
:::: column

#### Action Locations

##### Repository: 

> `<owner>/<repo>@<ref>`

##### Local Path: 

> `./<path-to-action>`

##### Docker Image: 

> `docker://<image>:<tag>`

::::
:::: column

#### Action Arguments

```yaml
steps:
  - name: <step>
    uses: <action>
    with:
      <arg>:<val>
```

::::
:::

### Dependencies

```yaml
jobs:
  <job>:
    needs: [<dependency>]
```

### Variables

::: columns
:::: column

#### Environment Variables

`${{ env.<VARIABLE> }}`

```yaml
env:
  <VAR>:<val>
```

::::
:::: column

#### Secrets

`${{ secrets.<SECRET> }}`

Set up on repository settings.

::::
:::

### Environments

Set up on repository settings.

::: columns
:::: column

- Secrets
- Variables
- Permissions

::::
:::: column

```yaml
jobs:
  <job>:
    environment: <environment>
```

::::
:::
### Artifacts

- `actions/upload-artifact`.
- `actions/download-artifact`.
- Manual download.

### Service Containers

```yaml
jobs:
  <job>:
    services:
      <service>:
        image: <image>:<tag>
        env:
          <VAR>: <val>
        ports:
          - <hport>:<cport>
        options: >-
          --<option> <arg>
```

### Caching

```yaml
steps:
  - name: <name>
    uses: actions/cache
    with:
      key: <cache-key>
      path: <path>
```

`${{ hashFile('<file>') }}`

### Matrix Strategy

`${{ matrix.<key> }}`

```yaml
jobs:
  <job>:
    continue-on-error: ${{ matrix.<boolkey> }}
    strategy:
      max-parallel: <num>
      fail-fast: <true/false>
      matrix:
        <key>: [<vals>]
          include:
            - <key>: <include>
          exclude:
            - <key>: <exclude>
```

## Custom Actions

::: columns
:::: column

#### Docker

```yaml
name: <name>
description: <description>
runs:
  using: 'docker'
  image: '<dockerfile>'
  args:
    - <args>
```

::::
:::: column

#### javascript

```yaml
name: <name>
description: <description>
runs:
  using: '<node-runner>'
  main: '<app>'
```

::::
:::

### Environment Variables

- **GITHUB_TOKEN:** temporary GitHub token.
- **GITHUB_REPOSITORY:** repo owner and name.
- **GITHUB_EVENT_PATH:** path to event payload file.

### Metadata

::: columns
:::: column

#### Required

- Action name
- Description
- Commands

::::
:::: column

#### Optional

- Author
- Inputs
- Outputs
- Branding

::::
:::

### Composite Actions

```yaml
name: <name>
descripton: <description>
runs:
  using: "composite"
  steps:
    - name: <step>
      uses: <action>
```

# RPM

## Packaging Workspace

`rpmdev-setuptree`

```
~/rpmbuild/
|-- BUILD
|-- RPMS
|-- SOURCES
|-- SPECS
`-- SRPMS
```

### Spec File

`rpmdev-newspec`

::: columns
:::: column

#### Preamble

- Name
- Version
- Release
- Summary
- License
- URL
- Source0
- Patch0
- BuildArch
- BuildRequires
- Requires

::::
:::: column

#### Body

- %description
- %prep
- %build
- %install
- %files
- %changelog

::::
:::

## Packages

::: columns
:::: column

#### Source Packages

`rpmbuild -bs <specfile>`

::::
:::: column

#### Binary Packages

```
rpmbuild -bb <specfile>
rpmbuild --rebuild <srpm>
```

::::
:::
