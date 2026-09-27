#!/bin/sh
set -eu

if [ -f /app/main.dart ]; then
  if [ ! -f /app/pubspec.yaml ]; then
    echo "error: /app/main.dart was found but /app/pubspec.yaml is missing" >&2
    exit 1
  fi

  cd /app
  dart pub get
  exec dart run /app/main.dart
fi

exec unpub -d "${DB_URL}"