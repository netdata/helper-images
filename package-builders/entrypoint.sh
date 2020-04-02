#!/bin/sh

fail() {
  printf "FAIL: %s\n" "$1"
  if [ -t 1 ]; then
    printf "Dropping into a shell..."
    exec /bin/sh
  fi
}

"${@}" || fail "build error"
