# Package

version       = "0.1.0"
author        = "doongjohn"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
namedBin["main"] = "simpleclicker"


# Dependencies

requires "nim >= 1.9.1"
requires "winim"


import std/os
import std/strformat


proc extractTaskArgs(taskName: string): seq[string] =
  let args = commandLineParams()
  let argStart = args.find(taskName) + 1
  args[argStart .. ^1]


task build_windows, "build windows exe":
  const zigcc = "{getCurrentDir()}/zigcc".fmt()
  # zig cc without pdb
  # https://ziggit.dev/t/how-to-use-zig-cc-without-generating-a-pdb-file/2873
  const zigccOption = "--target=x86_64-windows -Doptimize=ReleaseSmall -s"
  const srcFile = "src/main.nim"
  const exeName = "simpleclicker.exe"
  const args = "build_windows".extractTaskArgs().join(" ")

  exec "nim c " &
    """--cc:clang """ &
    """--clang.exe="{zigcc}" """.fmt() &
    """--clang.linkerexe="{zigcc}" """.fmt() &
    """--passC:"{zigccOption}" """.fmt() &
    """--passL:"{zigccOption}" """.fmt() &
    """--os:windows --opt:size -d:release """ &
    """-o:"{exeName}" """.fmt() &
    """{args} """.fmt() &
    """{srcFile}""".fmt()
