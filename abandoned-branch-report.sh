#!/bin/bash

MAINLINE_BRANCH_NAME=$1
UPSTREAM='origin'
MAINLINE_BRANCH="$UPSTREAM/$MAINLINE_BRANCH_NAME"
THRESHOLD='30 days ago'
LOGFILE='git-branch-cleanup.log'

for branch in `git branch -r --no-merged $MAINLINE_BRANCH | grep -vP "\b(master|$MAINLINE_BRANCH_NAME|HEAD)\b"`
do
  echo `git log -n 1 --format="%an %ae %m%m %ci %cr" $branch` ' ' $branch
  # last_commit_date=`git log -n 1 --format="%ci" $branch | awk '{print $1}'`
  # last_commit_age=`git log -n 1 --format="%cr" $branch`
  # last_committer=`git log -n 1 --format="%a" $branch`
done

