#!/bin/bash

# zig cc without pdb
# https://ziggit.dev/t/how-to-use-zig-cc-without-generating-a-pdb-file/2873

ZIGCC="$PWD/zigcc"
ZIGCC_OPTION="--target=x86_64-windows -Doptimize=ReleaseSmall -s"
OUTPUT="simpleclicker.exe"

nim c \
  --cc:clang \
  --clang.exe="$ZIGCC" \
  --clang.linkerexe="$ZIGCC" \
  --passC:"$ZIGCC_OPTION" \
  --passL:"$ZIGCC_OPTION" \
  --os:windows \
  --opt:size \
  -d:release \
  -o:"$OUTPUT" \
  "$@" \
  src/main.nim
