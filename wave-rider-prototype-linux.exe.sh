#!/bin/sh
echo -ne '\033c\033]0;Wave Rider\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/wave-rider-prototype-linux.exe.x86_64" "$@"
