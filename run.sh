#!/bin/sh

GITHUB_USER=
GITHUB_TOKEN=

subscribe() {
  for REPO in $1; do
    REPO=$(echo $REPO | sed -e 's/\"//g')
    API_URI="https://api.github.com/repos/${REPO}/subscription?access_token=${GITHUB_TOKEN}"
    echo $REPO $(curl -s -X PUT --data '{"subscribed": true,"ignored": false}' ${API_URI} | jq '. | { subscribed, ignored }')
  done
}

PAGE=1
REPOS=$(curl -s "https://api.github.com/orgs/${GITHUB_USER}/repos?access_token=${GITHUB_TOKEN}&page=${PAGE}" | jq ".[] | .full_name")
subscribe "$REPOS"

while [ -n "$REPOS" ]
do
  PAGE=$(($PAGE+1))
  REPOS=$(curl -s "https://api.github.com/orgs/${GITHUB_USER}/repos?access_token=${GITHUB_TOKEN}&page=${PAGE}" | jq ".[] | .full_name")
  subscribe "$REPOS"
done
