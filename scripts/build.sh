#!/usr/bin/env bash
set -euo pipefail

SCHEME=${SCHEME:-Pressi}
DEST=${DEST:-platform=iOS Simulator,name=iPhone 16 Pro}

echo "Building scheme: $SCHEME"
if command -v xcbeautify >/dev/null 2>&1; then
  xcodebuild -project Pressi.xcodeproj -scheme "$SCHEME" -destination "$DEST" build | xcbeautify
else
  xcodebuild -project Pressi.xcodeproj -scheme "$SCHEME" -destination "$DEST" build
fi
