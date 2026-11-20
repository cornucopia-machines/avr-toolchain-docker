# AVR toolchain image

The build environment for the org's AVR firmware
([spadefoot-toad-firmware](https://github.com/cornucopia-machines/spadefoot-toad-firmware)), in CI and in its
devcontainer: Alpine with avr-gcc, avr-libc, avrdude, CMake, Ninja, and Clang with clang-tidy.

It's published as `ghcr.io/cornucopia-machines/avr-toolchain`, for `linux/amd64` and `linux/arm64`, on every push to
`main` (or by running the [Build](.github/workflows/build.yml) workflow by hand):

- `sha-<short-sha>`: the commit's build, never moved. Consumers pin to its digest
  (`ghcr.io/cornucopia-machines/avr-toolchain@sha256:...`), so a new image changes nothing until they update it.
- `latest`: the newest build.

Look up a tag's digest with `docker buildx imagetools inspect ghcr.io/cornucopia-machines/avr-toolchain:<tag>`.

## Checks

- **Every build** smoke-tests the image (the tools run, and avr-gcc builds for the ATtiny1616), checks the
  `Dockerfile` for misconfigurations with Trivy, and scans a Syft SBOM of the image with Grype. A fixable
  vulnerability fails the build: the `Dockerfile` runs `apk upgrade`, so one that's left needs a newer Alpine
  release. The SBOM is a build artifact, and is attached to the published image as an attestation:
  `docker buildx imagetools inspect ghcr.io/cornucopia-machines/avr-toolchain:latest --format '{{ json .SBOM }}'`.
- **Weekly**, the [Image scan](.github/workflows/image-scan.yml) rescans `latest` and opens a `security` issue for
  each fixable vulnerability disclosed since. Running Build again picks up Alpine's fixes.
- **Dependabot** proposes new Alpine releases (the `FROM` is pinned to `alpine:3.x`) and action updates.
- The org's shared secret scan and Actions lint run on pull requests; see
  [cornucopia-machines/.github](https://github.com/cornucopia-machines/.github).

Skip a finding that doesn't apply in `.grype.yaml` or `.trivyignore`, with a comment saying why.
