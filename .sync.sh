#!/usr/bin/env bash
################################################################
# Copyright (c) 2021 Eliminater74
#
# Updated: 06/16/2021 Eliminater74
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# 
# Description: Script used to fetch/sync LEAD from lede source
################################################################
### I did not originally write this script, It was written 
### someone else whos name I am not sure of, All I did was
### Customized it to my needs, Pretty much modded it.
################################################################


# if error occured, then exit
set -e

# path
project_root_path=`pwd`
tmp_path="$project_root_path/.tmp"

if [ ! -d $tmp_path ]; then
    mkdir -p $tmp_path
fi

### git lede/lean
if [ ! -d $tmp_path/kernel ]; then
    mkdir -p $tmp_path/kernel
    cd $tmp_path/kernel
    git init
    git remote add origin https://github.com/coolsnowwolf/lede.git
    git config core.sparsecheckout true
fi
cd $tmp_path/kernel
if [ ! -e .git/info/sparse-checkout ]; then
    touch .git/info/sparse-checkout
fi
if [ `grep -c "package/kernel/mwlwifi" .git/info/sparse-checkout` -eq 0 ]; then
    echo "package/kernel/mwlwifi" >> .git/info/sparse-checkout
fi

git pull --depth 1 origin master

############################################################################################

### packages
if [ -d $project_root_path/mwlwifi ]; then
    rm -rf $project_root_path/mwlwifi
fi
cp -R $tmp_path/kernel/package/kernel/mwlwifi/* $project_root_path/

# 提交
# cd $tmp_path/lean 
# latest_commit_id=`git rev-parse HEAD`
# latest_commit_msg=`git log --pretty=format:"%s" $current_git_branch_latest_id -1`
# echo $latest_commit_id
# echo $latest_commit_msg


## luci-app-lean


cd $project_root_path
cur_time=$(date "+%Y%m%d-%H%M%S")
git add -A && git commit -m "$cur_time" && git push origin main
