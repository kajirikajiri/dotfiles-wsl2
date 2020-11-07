#!/bin/bash

# die returns exit code error and echo error message
function die {
    e_error "$1" 1>&2
    exit "${2:-1}"
}
export -f die
