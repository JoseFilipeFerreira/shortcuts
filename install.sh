cleanTasks() {
    for task in ~/.shortcuts/tasks/*
    do
        if [ -h "$task" ] && ! [ -e "$task" ]; then
            echo -e "\033[31mRemoving broken task: $(basename "$task")\033[0m"
            rm "$task"
        fi
    done
    return 1;
}

newTasks() {
    for task in tasks/*; do
        [ -h ~/.shortcuts/tasks/"$(basename "$task")" ] || return 0
    done
    return 1;
}

mkdir -p ~/.shortcuts/tasks
cd "$(dirname "$(realpath "$0")")" || return 0

cleanTasks
newTasks || exit 0

echo -e "\033[35mStoring Tasks...\033[0m"

for task in tasks/*
do
    task_name=$(basename "$task")
    if ! [ -h ~/.shortcuts/tasks/"$task_name" ]; then
        echo -e "\033[33m\t$task_name\033[0m"
        ln -s "$(pwd)/$task" ~/.shortcuts/tasks/"$task_name"
    fi
done
chmod +x tasks/*
echo -e "\033[35mDone!\033[0m"
