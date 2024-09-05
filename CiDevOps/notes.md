# GitHub Actions

## Workflow

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

#### Webhooks

```yaml
on:
  <event>:
    <event-filter>:
      - <filter>
```

#### Scheduled

```yaml
on:
  schedule:
    - cron: '* * * * *'
```

### Runners

- Ubuntu
- Windows
- macOS
- self-host

### Action Locations

- **Repository:** `<owner>/<repo>@<ref>`
- **Local Path:** `./<path-to-action>`
- **Docker Image:** `docker://<image>:<tag>`

### Dependencies

```yaml
jobs:
  <job>:
    needs: [<dependency>]
```

### Action Arguments

```yaml
steps:
  - name: <step>
    uses: <action>
    with:
      <arg>:<val>
```

### Environment Variables

`${{ env.<VARIABLE> }}`

```yaml
env:
  <VAR>:<val>
```

### Secrets

`${{ secrets.<SECRET> }}`

Set up on repository settings.

### Environments

```yaml
jobs:
  <job>:
    environment: <environment>
```

Set up on repository settings.

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

### Step Summaries

`$GITHUB_STEP_SUMMARY`

## Custom Actions

- Dockerfile
- entrypoint.sh
- action.yaml
- README.md

### Environment Variables

- **GITHUB_TOKEN:** temporary GitHub token.
- **GITHUB_REPOSITORY:** repo owner and name.
- **GITHUB_EVENT_PATH:** path to event payload file.

### Action Metadata

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

#### javascript

```yaml
name: <name>
description: <description>
runs:
  using: '<node-runner>'
  main: '<app>'
```

#### Required

- Action name
- Description
- Author
- Commands

#### Optional

- Inputs
- Outputs
- Branding

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

## Spec File

`rpmdev-newspec`

### Preamble

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

### Body

- %description
- %prep
- %build
- %install
- %files
- %changelog

## Source Packages

`rpmbuild -bs <specfile>`

## Binary Packages

```
rpmbuild -bb <specfile>
rpmbuild --rebuild <srpm>
```

