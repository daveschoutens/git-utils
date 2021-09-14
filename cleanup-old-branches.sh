#!/bin/bash

MAINLINE_BRANCH_NAME=$1
UPSTREAM='origin'
MAINLINE_BRANCH="$UPSTREAM/$MAINLINE_BRANCH_NAME"
THRESHOLD='30 days ago'
LOGFILE='git-branch-cleanup.log'

for branch in `git branch -r --merged $MAINLINE_BRANCH | grep -vP "\b(master|$MAINLINE_BRANCH_NAME|HEAD)\b"`
do
  merge_commit=`git log $MAINLINE_BRANCH ^$branch --ancestry-path --oneline | tail -1 | awk '{print $1}'`
  merge_commit_date=`git log -n 1 --format="%ci" $merge_commit | awk '{print $1}'`
  merge_commit_age=`git log -n 1 --format="%cr" $merge_commit`
  commit_epoch_second=$(date --date "$merge_commit_date" +'%s')
  threshold_epoch_second=$(date --date "$THRESHOLD" +'%s')
  if [ $commit_epoch_second -lt $threshold_epoch_second ]
  then
    branch_commit=`git log -1 --format='%H' $branch`
    branch_name=`echo $branch | grep -oP "(?<=$UPSTREAM/).*"`
    echo "DELETING stale branch '$branch_name' (SHA: $branch_commit) since it was merged into '$MAINLINE_BRANCH_NAME' on $merge_commit_date ($merge_commit_age)" | tee -a $LOGFILE
    git push -u $UPSTREAM :$branch_name
  fi
done

