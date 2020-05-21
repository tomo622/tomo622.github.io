#!/bin/sh
DIR="$( cd "$( dirname "$0" )" && pwd -P )"
cd $DIR
bundle exec jekyll serve