#!/bin/sh
set -eu

if [ -f /app/main.dart ]; then
  if [ ! -f /app/pubspec.yaml ]; then
    echo "error: /app/main.dart was found but /app/pubspec.yaml is missing" >&2
    exit 1
  fi

  cd /app
  if [ ! -f /app/.dart_tool/package_config.json ] || \
    [ ! -f /app/pubspec.lock ] || \
    [ /app/pubspec.yaml -nt /app/pubspec.lock ] || \
    [ /app/pubspec.yaml -nt /app/.dart_tool/package_config.json ] || \
    [ /app/pubspec.lock -nt /app/.dart_tool/package_config.json ]; then
    dart pub get
  fi
  exec dart run /app/main.dart
fi

exec unpub -d "${DB_URL}"