#!/bin/bash
cleanDir() {
    for file in "$1"/*
    do
        if [ -h "$file" ] && ! [ -e "$file" ]
        then
            echo  "\033[31mRemoving broken file: $(basename "$file")\033[0m"
            rm "$file"
        fi
    done
    return 1;
}

newDir() {
    for file in "$1"/*
    do
        [ -h "$2"/"$(basename "$file")" ] || return 1
    done
    return 0;
}

syncDir() {
    echo -e "\033[35mStoring $1...\033[0m"

    for file in "$1"/*
    do
        file_name=$(basename "$file")
        if ! [ -h "$2"/"$file_name" ]; then
            echo -e "\033[33m\t$file_name\033[0m"
            ln -s "$(pwd)/$file" "$2"/"$file_name"
        fi
    done
    chmod +x "$1"/*
}

mkdir -p ~/.shortcuts/tasks
cd "$(dirname "$(realpath "$0")")" || return 0

cleanDir ~/.shortcuts/tasks
cleanDir ~/.shortcuts

newDir tasks ~/.shortcuts/tasks || syncDir tasks ~/.shortcuts/tasks
newDir foreground_tasks ~/.shortcuts || syncDir foreground_tasks ~/.shortcuts

echo -e "\033[35mDone!\033[0m"
