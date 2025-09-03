#!/usr/bin/env bash
set -euo pipefail

SCHEME=${SCHEME:-Pressi}
DEST=${DEST:-platform=iOS Simulator,name=iPhone 16 Pro}

echo "Testing scheme: $SCHEME"
if command -v xcbeautify >/dev/null 2>&1; then
  xcodebuild -project Pressi.xcodeproj -scheme "$SCHEME" -destination "$DEST" test | xcbeautify
else
  xcodebuild -project Pressi.xcodeproj -scheme "$SCHEME" -destination "$DEST" test
fi
