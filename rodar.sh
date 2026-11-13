#!/bin/sh
# Monta (TASM), linka (TLINK) e roda um .asm no DOSBox-X.
# Uso: ./rodar.sh teste      (sem a extensao .asm)
NOME=${1:-teste}
cd "$(dirname "$0")"
dosbox-x -nopromptfolder -defaultconf \
  -c "mount c \"$(pwd)\"" \
  -c "c:" \
  -c "tools\\tasm\\tasm /zi $NOME.asm" \
  -c "tools\\tasm\\tlink /v $NOME.obj" \
  -c "$NOME.exe" \
  -c "exit"
