#!/bin/sh
set -eu

if [ -f /app/main.dart ]; then
  if [ ! -f /app/pubspec.yaml ]; then
    echo "error: /app/main.dart was found but /app/pubspec.yaml is missing" >&2
    exit 1
  fi

  cd /app
  checksum_file=/app/.dart_tool/docker-unpub-deps.cksum
  current_checksums="$(
    cksum /app/pubspec.yaml
    if [ -f /app/pubspec.lock ]; then
      cksum /app/pubspec.lock
    fi
  )"
  cached_checksums="$(cat "$checksum_file" 2>/dev/null || true)"

  if [ ! -f /app/.dart_tool/package_config.json ] || \
    [ ! -f /app/pubspec.lock ] || \
    [ "$current_checksums" != "$cached_checksums" ]; then
    dart pub get
    current_checksums="$(
      cksum /app/pubspec.yaml
      if [ -f /app/pubspec.lock ]; then
        cksum /app/pubspec.lock
      fi
    )"
    printf '%s\n' "$current_checksums" > "$checksum_file"
  fi
  exec dart run main.dart
fi

exec unpub -d "${DB_URL}"