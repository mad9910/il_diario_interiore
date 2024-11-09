#!/bin/bash
git clone https://github.com/flutter/flutter.git --depth 1 -b stable
export PATH="$PATH:$PWD/flutter/bin"
flutter precache
flutter doctor
