#!/bin/bash

COMPILER="$PWD/zigcc"
LINKER="$PWD/zigcc"
OPTIONS="-target x86_64-windows"
OUTPUT="simpleclicker.exe"

nim c --cc:clang --clang.exe="$COMPILER" --clang.linkerexe="$LINKER" --passC:"$OPTIONS" --passL:"$OPTIONS" --os:windows --forceBuild:on -d:release -o:"$OUTPUT" src/main.nim
