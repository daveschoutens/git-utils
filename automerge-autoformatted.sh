#!/bin/bash

for file in $(git diff --name-only --diff-filter=U | grep 'java$');
do
	git show :1:$file > $file.common.java
	git show :2:$file > $file.ours.java
	git show :3:$file > $file.theirs.java
	java -jar ~/Downloads/google-java-format-1.8-all-deps.jar --replace $file.{common,ours,theirs}.java
	git merge-file -p $file.{ours,common,theirs}.java > $file
done

