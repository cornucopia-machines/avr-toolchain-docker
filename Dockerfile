# Pinned to an Alpine release rather than `latest`, so a new release arrives as a Dependabot PR
# that CI builds and scans first. Alpine, because it packages a recent avr-gcc (Debian's is much
# older) and keeps the image small.
FROM alpine:3.24

LABEL org.opencontainers.image.source=https://github.com/cornucopia-machines/avr-toolchain-docker
LABEL org.opencontainers.image.description="AVR toolchain (avr-gcc, avr-libc, avrdude, CMake, Ninja, Clang) for building ATtiny firmware"

# `apk upgrade` brings the base image's own packages up to the release's latest fixes, which the
# Alpine image only gets when it's rebuilt; the Grype check in CI fails on what's still fixable.
# Clang and clang-extra-tools (clang-tidy) are here so firmware CI doesn't install them on every run.
RUN apk --no-cache upgrade && \
    apk --no-cache add \
    ca-certificates \
    wget \
    make \
    cmake \
    ninja \
    git \
    zsh \
    avrdude \
    avr-libc \
    gcc-avr \
    clang \
    clang-extra-tools

WORKDIR /work
