# Package

version       = "0.1.0"
author        = "doongjohn"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
namedBin["main"] = "simpleclicker"


# Dependencies

requires "nim >= 2.0.0"
requires "winim"


# Tasks

import std/os
import std/strformat

proc getTaskArgs(taskName: string): seq[string] =
  let args = commandLineParams()
  let argStart = args.find(taskName) + 1
  args[argStart .. ^1]

task build_windows, "build windows exe via zig cc":
  const
    zigcc = fmt("{getCurrentDir()}/zigcc")
    zigccArgs = "--target=x86_64-windows -Doptimize=ReleaseSmall -s" # https://ziggit.dev/t/how-to-use-zig-cc-without-generating-a-pdb-file

  const
    srcFile = "src/main.nim"
    exeName = "simpleclicker.exe"
    nimcArgs = getTaskArgs("build_windows").join(" ")

  exec "nim c " & [
    fmt("--cc:clang --clang.exe=\"{zigcc}\" --clang.linkerexe=\"{zigcc}\""),
    fmt("--passC:\"{zigccArgs}\""),
    fmt("--passL:\"{zigccArgs}\""),
    "--os:windows",
    "--opt:size",
    "-d:release",
    fmt("-o:\"{exeName}\""),
    fmt("{nimcArgs}"),
    fmt("{srcFile}"),
  ].join(" ")
