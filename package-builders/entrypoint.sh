#!/bin/sh

if [ -d /cmake/bin ]; then
    PATH="/cmake/bin:${PATH}"
fi

if [ -n "$NETDATA_SENTRY_DSN" ]; then
  SENTRY_DSN="$NETDATA_SENTRY_DSN"
fi

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
