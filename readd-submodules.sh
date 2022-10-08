#!/bin/bash
###
# File: readd-submodules.sh
# Author: Leopold Meinel (leo@meinel.dev)
# -----
# Copyright (c) 2022 Leopold Meinel & contributors
# SPDX ID: GPL-3.0-or-later
# URL: https://www.gnu.org/licenses/gpl-3.0-standalone.html
# -----
###

set -eu

DIR=$(dirname "$0")
cd "${DIR:?}"
readarray -t SUBMODULES < <(git submodule status | cut -d' ' -f2 | tr -d "[:blank:]")
SUBMODULES_LENGTH="${#SUBMODULES[@]}"
git submodule init
git submodule update
git submodule deinit -f --all
for ((i = 0; i < SUBMODULES_LENGTH; i++)); do
    rm -rf "${DIR:?}/${SUBMODULES[$i]}"
    rm -rf "${DIR:?}/.git/modules/${SUBMODULES[$i]}"
    {
        unset 'SUBMODULES[$i]'
        continue
    }
    SUBMODULES=("${SUBMODULES[@]}")
done
rm -rf "${DIR:?}/.gitmodules"
git add .
git commit -m "Remove submodules" || true
git submodule add git@github.com:LeoMeinel/dropconfirm.git
git submodule add git@github.com:LeoMeinel/gbooster.git
git submodule add git@github.com:LeoMeinel/papermc-plugins-vital.git
git submodule add git@github.com:LeoMeinel/randomspawntp.git
git submodule add git@github.com:LeoMeinel/specplayer.git
git submodule init
git submodule sync
git submodule update --remote --merge
git add .
git commit -m "Add submodules" || true
