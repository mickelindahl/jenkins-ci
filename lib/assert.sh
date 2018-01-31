#!/usr/bin/env bash

. ./jenkins-ci/lib/print_stack.sh

assert () {

    for arg in "$@"; do

        echo "arg"${!arg}

        if [ -d ${!arg} ];then
            print_stack "Missing env $arg"
            exit 1
        fi

    done

}
