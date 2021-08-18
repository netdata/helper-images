#!/bin/sh

fail() {
  printf "FAIL: %s\n" "$1"
  if [ -t 1 ]; then
    printf "Dropping into a shell..."
    exec /bin/sh
  else
    exit 1
  fi
}

"${@}" || fail "build error"
