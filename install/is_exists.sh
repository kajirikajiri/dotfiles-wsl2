#!/bin/bash

# is_exists returns true if executable $1 exists in $PATH
function is_exists {
    type "$1" >/dev/null 2>&1
    return $?
}
export -f is_exists
