#!/bin/bash

set -e

function killJekyll {
    SERVER_PID=`lsof -i -n -P | grep jekyll | grep 127.0.0.1:4000 | awk '{ print $2; }'`
    if [ $SERVER_PID ];
    then
        kill $SERVER_PID
    fi
}

function finish {
    STATUS=$?
    killJekyll
    exit $STATUS
}
trap finish EXIT

jekyll build
jekyll serve -B -P 4000 -H 127.0.0.1 -c _config.yml,_config.travis.yml

htmlproof --disable-external --check-html --check-favicon ./_site

killJekyll
