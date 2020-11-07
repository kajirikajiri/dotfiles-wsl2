#!/bin/bash

function is_exists {
    type "$1" >/dev/null 2>&1
    return $?
}
export -f is_exists
