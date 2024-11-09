#!/bin/bash
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"
flutter precache
flutter build web --release --web-renderer canvaskit
