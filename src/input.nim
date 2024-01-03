import pkg/winim/lean
import keycodes


var
  # TODO: use bit array instead?
  prevStateKeyDown: set[KeyCode]
  curStateKeyPressed: set[KeyCode]
  curStateKeyReleased: set[KeyCode]


proc resetKeyboardInput* =
  prevStateKeyDown = {}
  curStateKeyPressed = {}
  curStateKeyReleased = {}


proc pollKeyboardInput*(excludes: set[KeyCode] = {}) =
  for i in 1 ..< 255:
    if excludes.contains(KeyCode(i)):
      continue

    let pressed = GetAsyncKeyState(int32(i)) < 0
    let key = KeyCode(i)

    curStateKeyPressed.excl(key)
    curStateKeyReleased.excl(key)

    if pressed and not prevStateKeyDown.contains(key):
      # key pressed
      prevStateKeyDown.incl(key)
      curStateKeyPressed.incl(key)
    elif not pressed and prevStateKeyDown.contains(key):
      # key released
      prevStateKeyDown.excl(key)
      curStateKeyReleased.incl(key)


proc isKeyPressed*(key: KeyCode): bool =
  curStateKeyPressed.contains(key)


proc isKeyDown*(key: KeyCode): bool =
  prevStateKeyDown.contains(key)


proc isKeyUp*(key: KeyCode): bool =
  curStateKeyReleased.contains(key)


proc getPressedKeys*: set[KeyCode] =
  curStateKeyPressed


proc getPressedKey*: KeyCode =
  result = KeyCode(0)
  for key in getPressedKeys():
    result = key


proc getDownKeys*: set[KeyCode] =
  prevStateKeyDown


proc getDownKey*: KeyCode =
  result = KeyCode(0)
  for key in getDownKeys():
    result = key


proc getReleasedKeys*: set[KeyCode] =
  curStateKeyReleased


proc getReleasedKey*: KeyCode =
  result = KeyCode(0)
  for key in getReleasedKeys():
    result = key
