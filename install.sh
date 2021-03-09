#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")

[ -d ~/storage ] || termux-setup-storage

task_set() {
    echo -e "\033[35mSetting task:\033[33m $1 (every: $2 ms)\033[0m"
    termux-job-scheduler \
        --script "$DIR/$1" \
        --period-ms "$2" \
        --persisted true
}

termux-job-scheduler --cancel-all
task_set tasker/change_lock 900000

files=(
tasker
settings/colors.properties
settings/termux.properties
)

echo -e "\033[35mCreating Links:\033[0m"
for file in "${files[@]}"; do
    ln -fvsn "$DIR/$file" ~/.termux/"$(basename "$file")" | sed "s|$HOME|~|g;s|'||g"
done

termux-reload-settings
