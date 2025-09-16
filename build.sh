#!/bin/bash


ASSEMBLY_PATH="./scad/assembly/assembly.scad"
ASSEMBLY_PARTS=("all" "base" "lid" "keystone_panel")
RENDER_PART=
OUTPUT_PATH="./stl"
NUM_THREADS=4

log() {
    local timestamp="$(date '+[%Y-%m-%d][%H:%M:%S]')"
    local message="$1"
    echo "${timestamp} - ${message}" 
}

help() {
    echo "Usage: build.sh [-i <file>] [-o <dir>] [-p <part>] [-t <num>]"
    echo
    echo "  -i <file>   Path to the input assembly scad file. Default is ${ASSEMBLY_PATH}."
    echo "  -o <dir>    Path to the output stl directory. Default is ${OUTPUT_PATH}"
    echo "  -r <part>   Name of the part to render. Acceptable values are [${ASSEMBLY_PARTS[@]}]. By default everything in the list will be rendered"
    echo "  -t <num>    Number of threads to use for rendering. Default is ${NUM_THREADS}. Threads are only used if you are not providing a render argument"
    echo "  -h          Displays this help message"
    exit 0
}

clean_artifacts() {
    local output_path=$1
    local render_part=$2
    log "Deleting old artifact: ${output_path}/${render_part}.stl"
    rm "${output_path}/${render_part}.stl" || true
}

create_output_path() {
    log "Creating output directory if it does not exist"
    mkdir -p ${OUTPUT_PATH}
}

render_part() {
    local assembly_path=$1
    local output_path=$2
    local render_part=$3

    clean_artifacts "${output_path}" "${render_part}"

    log "Started rendering [${render_part}]..."
    openscad-nightly -q \
        -D "render_${render_part}();" \
        -o "${output_path}/${render_part}.stl" \
        "${assembly_path}"
    log "Finished rendering [${render_part}]!"
}

while getopts ":i:o:r:t:h" opt; do
    case $opt in
        i)  # assembly path argument
            ASSEMBLY_PATH="$OPTARG"
            ;;
        o)  # output directory argument
            OUTPUT_PATH="$OPTARG"
            ;;
        r)  # part to render argument
            RENDER_PART="$OPTARG"
            ;;
        t)  # number of threads argument
            NUM_THREADS="$OPTARG"
            ;;
        h)  # Verbose flag (no argument)
            help
            ;;
        \?) # Unknown option
            echo "Error: Invalid option -$OPTARG" >&2
            usage
            ;;
        :)  # Missing argument for an option that expects one
            echo "Error: Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

create_output_path

if [ -z ${RENDER_PART} ]; then
    export -f render_part
    export -f log
    export -f clean_artifacts

    parallel --line-buffer -j ${NUM_THREADS} render_part "${ASSEMBLY_PATH}" "${OUTPUT_PATH}" ::: "${ASSEMBLY_PARTS[@]}"
else
    render_part "${ASSEMBLY_PATH}" "${OUTPUT_PATH}" "${RENDER_PART}"
fi