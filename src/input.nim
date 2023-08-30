import
  pkg/winim/lean,

  keycodes


var
  # TODO: use bit array instead?
  prevStateDown: set[KeyCode]
  curStatePressed: set[KeyCode]
  curStateReleased: set[KeyCode]


proc resetInput* =
  prevStateDown = {}
  curStatePressed = {}
  curStateReleased = {}


proc pollInput*(excludes: set[KeyCode] = {}) =
  for i in 1 ..< 255:
    if excludes.contains(KeyCode(i)):
      continue

    let pressed = GetAsyncKeyState(int32(i)) < 0
    let key = KeyCode(i)

    curStatePressed.excl(key)
    curStateReleased.excl(key)

    if pressed and not prevStateDown.contains(key):
      # key pressed
      prevStateDown.incl(key)
      curStatePressed.incl(key)
    elif not pressed and prevStateDown.contains(key):
      # key released
      prevStateDown.excl(key)
      curStateReleased.incl(key)


proc isKeyPressed*(key: KeyCode): bool =
  curStatePressed.contains(key)


proc isKeyDown*(key: KeyCode): bool =
  prevStateDown.contains(key)


proc isKeyUp*(key: KeyCode): bool =
  curStateReleased.contains(key)


proc getPressedKeys*: set[KeyCode] =
  curStatePressed


proc getPressedKey*: KeyCode =
  result = KeyCode(0)
  for key in getPressedKeys():
    result = key


proc getDownKeys*: set[KeyCode] =
  prevStateDown


proc getDownKey*: KeyCode =
  result = KeyCode(0)
  for key in getDownKeys():
    result = key


proc getReleasedKeys*: set[KeyCode] =
  curStateReleased


proc getReleasedKey*: KeyCode =
  result = KeyCode(0)
  for key in getReleasedKeys():
    result = key
