#!/usr/bin/env bash
set -e

echo "========================================================"
echo "  VisionGate Web - Render Build Pipeline                "
echo "========================================================"

# Check if pre-compiled artifacts exist
if [ -d "web_build" ] && [ -f "web_build/index.html" ]; then
    echo "[✓] Pre-compiled Flutter Web distribution verified in web_build/."
    echo "[✓] Deployment ready!"
fi

# Optional re-compilation trigger
if [ "${REBUILD_FLUTTER}" = "true" ] || [ ! -f "web_build/index.html" ]; then
    echo "[i] Installing Flutter SDK..."
    if [ ! -d "$HOME/flutter" ]; then
        git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$HOME/flutter"
    fi
    export PATH="$PATH:$HOME/flutter/bin"
    
    echo "[i] Compiling Flutter Web..."
    cd siet_sync
    flutter config --enable-web
    flutter pub get
    flutter build web --release --base-href /
    cd ..
    
    mkdir -p web_build
    cp -r siet_sync/build/web/* web_build/
    echo "[✓] Flutter Web compilation completed successfully!"
fi

echo "========================================================"
echo "  Build Completed Successfully                          "
echo "========================================================"
