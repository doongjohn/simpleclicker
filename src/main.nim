import
  std/os,
  std/times,

  pkg/winim/lean,

  keycodes,
  input


const
  holdTime = 1
  delay = 1

var
  runApp = true
  active = false
  keys: tuple[
    activation: KeyCode,
    deactivation: KeyCode,
  ]


proc handleInitialEnterKey =
  # wait for the user to release the enter key
  pollInput()
  if getDownKeys().contains(KeyEnter):
    while getReleasedKey() != KeyEnter:
      pollInput()
      sleep(1)


proc main =
  echo "[simple auto clicker 👇👇👇]"
  handleInitialEnterKey()

  # set activation key
  stdout.write("> activation key: ")
  while keys.activation == KeyNone:
    pollInput(excludes = {Key_Shift, Key_Ctrl, Key_Alt})
    keys.activation = getReleasedKey()
    if keys.activation != KeyNone:
      echo keys.activation

  # set deactivation key
  stdout.write("> deactivation key: ")
  while keys.deactivation == KeyNone:
    pollInput(excludes = {Key_Shift, Key_Ctrl, Key_Alt})
    keys.deactivation = getReleasedKey()
    if keys.deactivation != KeyNone:
      echo keys.deactivation

  echo "> press ctrl+c to exit"

  setControlCHook proc {.noconv.} =
    runApp = false

  # app loop
  while runApp:
    pollInput()

    if not active and isKeyPressed(keys.activation):
      # activate
      echo "* ", times.now().format("hh tt : mm'm' : ss's'"), " | 👇 started!"
      active = true
    elif active and isKeyPressed(keys.deactivation):
      # deactivate
      echo "* ", times.now().format("hh tt : mm'm' : ss's'"), " | ❌ stopped!"
      active = false

    # auto click
    if active:
      mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
      sleep(holdTime)
      mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
      sleep(delay)
    else:
      sleep(1)


main()
