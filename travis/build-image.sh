#!/usr/bin/env bash
set -e
echo "Branch: ${TRAVIS_BRANCH}"
echo "TAG: ${TRAVIS_TAG}"

if [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_TAG" != "" ]; then
  echo -e 'Build Branch for Release => Branch ['$TRAVIS_BRANCH']  Tag ['$TRAVIS_TAG']'
  if [ -z "${AWS_ACCESS_KEY_ID+xxx}" ]; then echo "AWS_ACCESS_KEY_ID is not set at all";i exit 1; fi
  if [ -z "AWS_ACCESS_KEY_ID" -a "${AWS_ACCESS_KEY_ID+xxx}" = "xxx" ]; then echo "AWS_ACCESS_KEY_ID is set but empty"; exit 1; fi
  if [ -z "${AWS_SECRET_ACCESS_KEY+xxx}" ]; then echo "AWS_SECRET_ACCESS_KEY is not set at all"; exit 1;fi
  if [ -z "AWS_SECRET_ACCESS_KEY" -a "${AWS_SECRET_ACCESS_KEY+xxx}" = "xxx" ]; then echo AWS_SECRET_ACCESS_KEY is set but empty;exit 1; fi

  export creator=$(git --no-pager show -s --format='%ae' ${TRAVIS_COMMIT})
  export creation_time=`date +"%Y%m%d%H%M%S"`
  export appversion="${TRAVIS_TAG}"
  export ec2_source_ami=ami-a10897d6
  export PATH="/opt/packer-0.8.6/bin:$PATH"

  CWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
  cd ./packer
  echo "CWD ${CWD}"

  (packer -machine-readable build $1 | sudo tee output.txt)&

  jobs_count=$(jobs -rp | wc -l)
  sleep_time=10

  until [ $jobs_count -eq "0" ]; do
     jobs_count=$(jobs -rp | wc -l)
     echo "remaining jobs count:$jobs_count"
     sleep $sleep_time
  done

  tail -2 output.txt | head -2 | awk 'match($0, /ami-.*/) { print substr($0, RSTART, RLENGTH) }' >  ami.txt
else
  echo branch, not a tag;
  exit 1;
fi
