import
  # std
  std/os,
  std/times,

  # pkg
  winim/lean,

  # modules
  keycodes,
  input


var
  runApp = true
  keys: tuple[
    activation: KeyCode,
    deactivation: KeyCode,
  ]

const
  holdTime = 1
  delay = 1


proc handleInitialEnterKey =
  # wait for the user to release the enter key
  pollInput()
  if getDownKeys().contains(KeyEnter):
    while getReleasedKey() != KeyEnter:
      pollInput()
      sleep(1)


proc main =
  setControlCHook proc {.noconv.} =
    runApp = false

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

  # run app
  var active = false
  while runApp:
    pollInput()

    if not active and isKeyPressed(keys.activation):
      # activate
      echo format(times.now(), "'*' hh tt : mm'm' : ss's'") & " | 👇 started!"
      active = true
    elif active and isKeyPressed(keys.deactivation):
      # deactivate
      echo format(times.now(), "'*' hh tt : mm'm' : ss's'") & " | ❌ stopped!"
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
