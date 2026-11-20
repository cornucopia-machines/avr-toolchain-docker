#!/usr/bin/env bash
# Checks that the image built as IMAGE has the tools the firmware builds need, and that avr-gcc can
# compile and link for the firmware's MCU, so a broken package doesn't get published as `latest`.
set -euo pipefail

: "${IMAGE:?}"

docker run --rm "$IMAGE" sh -euc '
    avr-gcc --version
    cmake --version
    ninja --version
    command -v avrdude
    clang --version
    clang-tidy --version
    printf "#include <avr/io.h>\nint main(void) { PORTA.DIR = 1; for (;;) {} }\n" > /tmp/t.c
    avr-gcc -mmcu=attiny1616 -Os -o /tmp/t.elf /tmp/t.c
    avr-objcopy -O ihex /tmp/t.elf /tmp/t.hex
'
