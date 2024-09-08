import std/os
import std/times
import pkg/winim/lean
import keycodes
import input


const
  holdTime = 1
  delay = 1

var
  run = true
  autoClickActive = false
  keys: tuple[
    activation: KeyCode,
    deactivation: KeyCode,
  ]


proc handleInitialEnterKey =
  # wait for the user to release the enter key
  pollKeyboardInput()
  if getDownKeys().contains(Key_Enter):
    while getReleasedKey() != Key_Enter:
      pollKeyboardInput()
      sleep(1)


proc main =
  echo "[simple auto clicker 👇👇👇]"

  handleInitialEnterKey()

  # set activation key
  stdout.write("> activation key: ")
  while keys.activation == Key_None:
    pollKeyboardInput(excludes = {Key_Shift, Key_Ctrl, Key_Alt})
    keys.activation = getReleasedKey()
    if keys.activation != Key_None:
      echo keys.activation

  # set deactivation key
  stdout.write("> deactivation key: ")
  while keys.deactivation == Key_None:
    pollKeyboardInput(excludes = {Key_Shift, Key_Ctrl, Key_Alt})
    keys.deactivation = getReleasedKey()
    if keys.deactivation != Key_None:
      echo keys.deactivation

  echo "> press ctrl+c to exit"

  setControlCHook proc {.noconv.} =
    run = false

  # app loop
  while run:
    pollKeyboardInput()

    if not autoClickActive and keys.activation.isPressed():
      # activate
      autoClickActive = true
      echo "* ", times.now().format("hh tt : mm'm' : ss's'"), " | 👇 started!"
    elif autoClickActive and keys.deactivation.isPressed():
      # deactivate
      autoClickActive = false
      echo "* ", times.now().format("hh tt : mm'm' : ss's'"), " | ❌ stopped!"

    # auto click
    if autoClickActive:
      mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
      sleep(holdTime)
      mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
      sleep(delay)
    else:
      sleep(1)


main()
