#!/bin/bash

if [ -n "$GITHUB_API_KEY" ]; then
  git ls-remote --exit-code origin stress-test
  if ! test $? = 0; then
    git branch -D stress-test
    git checkout -b stress-test
    cp tests/stress/.travis.yml .travis.yml
    git add .travis.yml
    git -c user.name='travis' -c user.email='travis' commit -m "Updated travis.yml for stress tests"
    git push -f -q https://DhavalKapil:$GITHUB_API_KEY@github.com/DhavalKapil/elasticsearch-lua stress-test
  fi
fi
