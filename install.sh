#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")

color_file="$DOTFILES/powertools/termite.conf"

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
settings/termux.properties
)

echo -e "\033[35mCreating Links:\033[0m"
for file in "${files[@]}"; do
    ln -fvsn "$DIR/$file" ~/.termux/"$(basename "$file")" | sed "s|$HOME|~|g;s|'||g"
done

echo -e "\033[35mGenerating colorscheme from $(echo "$color_file" | sed "s|$HOME|~|g")\033[0m"
[ -f "$color_file" ] && \
    grep -E '^(color[0-9]+|background|foreground) = #' "$color_file" |
    sed 's/ = /: /g' \
    >| ~/.termux/colors.properties

termux-reload-settings
