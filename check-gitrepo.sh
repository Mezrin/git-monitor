#!/bin/bash

#####
##### Input
#####
if [ $# -ne "3" ]
then
    echo "---> $(date +'%F %T') >>> Usage (3 arguments): $(readlink -f $0) GitRepoURL TargetBranch LastKnownCommit"
    exit 85
fi

REPO_URL=${1}                 # URL to git repo
TARGET_BRANCH=${2}            # Branch that we need to check
LAST_COMMIT=${3}              # Last known commit on that branch

echo "---> $(date +'%F %T') >>> Starting to check branch '${TARGET_BRANCH}' in repo '${REPO_URL}' for new commits. Last known commit '${LAST_COMMIT}'"


#####
##### Check remote repo
#####
COUNTER=$(git ls-remote --heads "${REPO_URL}" "${TARGET_BRANCH}" | grep "${LAST_COMMIT}" | wc -l)

if [ ${COUNTER} -ne '1' ]; then
    echo "---> $(date +'%F %T') >>> Given commit is not the last in branch '${TARGET_BRANCH}' of repo '${REPO_URL}' or branch was deleted. Send email"
    exit 1
else
    echo "---> $(date +'%F %T') >>> Successfully checked branch '${TARGET_BRANCH}' in repo '${REPO_URL}'"
    exit 0
fi
