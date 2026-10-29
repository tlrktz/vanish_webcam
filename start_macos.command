#!/bin/bash
# macOS launcher: double-click in Finder, or run ./start_macos.command [options] in Terminal.
# Options are passed to vanish_cam.py, for example: --mode naruto, --no-virtual-camera.
cd "$(dirname "$0")" || exit 1

VENV_DIR=".venv-local"
VENV_PY="$VENV_DIR/bin/python"

fail() {
  echo
  echo "[Vanish Lab] $1"
  echo "Leggi la sezione macOS del README per le soluzioni comuni."
  read -r -p "Premi Invio per chiudere..." _
  exit 1
}

if [ ! -x "$VENV_PY" ]; then
  # mediapipe and pygame publish macOS wheels for Python 3.10-3.13.
  PYTHON=""
  for candidate in python3.12 python3.13 python3.11 python3.10 python3; do
    if command -v "$candidate" >/dev/null 2>&1 &&
       "$candidate" -c 'import sys; sys.exit(not (3, 10) <= sys.version_info[:2] <= (3, 13))' 2>/dev/null; then
      PYTHON="$candidate"
      break
    fi
  done
  [ -n "$PYTHON" ] || fail "Serve Python 3.10-3.13. Installalo con: brew install python@3.12"
  echo "[Vanish Lab] Creo l'ambiente Python locale con $PYTHON..."
  "$PYTHON" -m venv "$VENV_DIR" || fail "Impossibile creare l'ambiente Python."
fi

if ! "$VENV_PY" -c "import cv2, mediapipe, numpy, pyvirtualcam" >/dev/null 2>&1; then
  if [ "$("$VENV_PY" -c 'import platform; print(platform.machine())')" = "arm64" ]; then
    REQUIREMENTS="requirements.txt"
  else
    REQUIREMENTS="requirements-macos-intel.txt"
  fi
  echo "[Vanish Lab] Installo i componenti necessari. Serve internet solo questa volta..."
  "$VENV_PY" -m pip install --upgrade pip || fail "Installazione non riuscita."
  "$VENV_PY" -m pip install -r "$REQUIREMENTS" || fail "Installazione non riuscita."
fi

echo "[Vanish Lab] Avvio la webcam..."
"$VENV_PY" vanish_cam.py "$@" || fail "Impossibile avviare Vanish Lab."
