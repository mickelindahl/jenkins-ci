#!/usr/bin/env bash

. ./ci/lib/print_stack.sh

assert () {

    for arg in "$@"; do

        if [ -d ${!arg} ];then
            print_stack "Missing env $arg"
            exit 1
        fi

    done

}
