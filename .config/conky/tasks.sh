#!/bin/bash

opt="$1"
title_color="$2"
task_color="$3"

IFS='
'

due=()

function print_due_list() {
    title=""
    case "$1" in
        ".before:today")
            title="Overdue Tasks:"
            ;;
        ":today")
            title="Tasks Due Today:"
            ;;
        ":tomorrow")
            title="Tasks Due Tomorrow:"
            ;;
        ":2d")
            date=$(date --date="today + 2 days" "+%a, %b %d")
            title="Tasks Due on $date"
            ;;
        ":3d")
            date=$(date --date="today + 3 days" "+%a, %b %d")
            title="Tasks Due on $date"
            ;;
        ":4d")
            date=$(date --date="today + 4 days" "+%a, %b %d")
            title="Tasks Due on $date"
            ;;
        ":5d")
            date=$(date --date="today + 5 days" "+%a, %b %d")
            title="Tasks Due on $date"
            ;;
        ":6d")
            date=$(date --date="today + 6 days" "+%a, %b %d")
            title="Tasks Due on $date"
            ;;
    esac

    echo "\${$title_color}$title"
    for t in "${due[@]}"
    do
        tsk=$(echo "$t" | sed -e 's/^00:00 //' -e 's/^/    /')
        echo "\${$task_color}$tsk"
    done
}

for day in .before:today :today :tomorrow :2d :3d :4d :5d :6d
do
    due=()
    case "$opt" in
        bills)
            for tsk in $(task conky tags.has:Bills due${day} | \
                sed -r -e '/^$/d' -e '/^[- ]+$/d' -e '/^[0-9]+ tasks?$/d' -e '/^No matches\.$/d' \
                       -e '/^Due *Description$/d' -e 's/^[0-9]{8}([0-9]{2})([0-9]{2})/\1:\2/')
            do
                due=("${due[@]}" "$tsk")
            done
            ;;
        tv)
            for tsk in $(task conky tags.has:TV due${day} | \
                sed -r -e '/^$/d' -e '/^[- ]+$/d' -e '/^[0-9]+ tasks?$/d' -e '/^No matches\.$/d' \
                       -e '/^Due *Description$/d' -e 's/^[0-9]{8}([0-9]{2})([0-9]{2})/\1:\2/')
            do
                due=("${due[@]}" "$tsk")
            done
            ;;
        other)
            for tsk in $(task conky tags.hasnt:Bills tags.hasnt:TV due${day} | \
                sed -r -e '/^$/d' -e '/^[- ]+$/d' -e '/^[0-9]+ tasks?$/d' -e '/^No matches\.$/d' \
                       -e '/^Due *Description$/d' -e 's/^[0-9]{8}([0-9]{2})([0-9]{2})/\1:\2/')
            do
                due=("${due[@]}" "$tsk")
            done
            ;;
    esac
    if [ "${#due[@]}" -gt 0 ]; then
        print_due_list "$day"
    fi
done
