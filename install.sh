#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")

task_set() {
    echo -e "\033[35mSetting task:\033[33m $1 (every: $2 ms)\033[0m"
    termux-job-scheduler \
        --script "$DIR/$1" \
        --period-ms "$2" \
        --persisted true
}

termux-job-scheduler --cancel-all
task_set shorts/tasks/change_lock 900000

echo -e "\033[35mStoring Tasks...\033[33m"
    ln -fvsn "$DIR/shorts" ~/.shortcuts | sed "s|$HOME|~|g;s|'||g"
echo -e "\033[35mDone!\033[0m"
