#!/bin/bash

ASSEMBLY_PATH="./scad/assembly/assembly.scad"
ASSEMBLY_PARTS=("all" "base" "lid" "stand")
OUTPUT_PATH="./stl"

log() {
    local timestamp="$(date '+[%Y-%m-%d][%H:%M:%S]')"
    local message="$1"
    echo "${timestamp} - ${message}" 
}

log "Removing old stl files"
rm ./stl/*

log "Starting render process..."

for part in "${ASSEMBLY_PARTS[@]}"; do
    log "Started rendering [${part}]"
    openscad-nightly -q \
        -D "RENDER_FUNCTION=\"render_${part}\";" \
        -o "${OUTPUT_PATH}/${part}.stl" \
        "${ASSEMBLY_PATH}"
    log "Finished rendering [${part}]"
done

log "Finished render process"

