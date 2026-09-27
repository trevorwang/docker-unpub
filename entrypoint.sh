#!/bin/sh
set -eu

if [ -f /app/main.dart ]; then
  if [ ! -f /app/pubspec.yaml ]; then
    echo "error: /app/main.dart was found but /app/pubspec.yaml is missing" >&2
    exit 1
  fi

  cd /app
  checksum_dir=/tmp/docker-unpub
  checksum_file="$checksum_dir/deps.cksum"
  mkdir -p "$checksum_dir"
  current_checksums="$(
    cksum /app/pubspec.yaml
    if [ -f /app/pubspec.lock ]; then
      cksum /app/pubspec.lock
    else
      printf '%s\n' 'pubspec.lock:missing'
    fi
  )"
  cached_checksums=''
  if [ -r "$checksum_file" ]; then
    cached_checksums="$(cat "$checksum_file")"
  fi

  if [ ! -f /app/.dart_tool/package_config.json ] || \
    [ "$current_checksums" != "$cached_checksums" ]; then
    dart pub get
    current_checksums="$(
      cksum /app/pubspec.yaml
      if [ -f /app/pubspec.lock ]; then
        cksum /app/pubspec.lock
      else
        printf '%s\n' 'pubspec.lock:missing'
      fi
    )"
    printf '%s\n' "$current_checksums" > "$checksum_file"
  fi
  exec dart run main.dart
fi

exec unpub -d "${DB_URL}"