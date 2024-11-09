#!/bin/bash

# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable flutter-sdk

# Aggiungi Flutter al PATH
export PATH="$PATH:$PWD/flutter-sdk/bin"

# Verifica l'installazione
flutter doctor -v

# Abilita il web
flutter config --enable-web
