#!/bin/bash


# get bash to do math with $((math+here))
# note: () means command
# (()) means do this operation?

# $1 is first parameter, $2 is second, etc.
# Add two numbers.
if [ $# -ne 2 ]; then
    echo "Supply two numbers, no more, no less"
    exit 1
fi

first=$1
second=$2

echo "The sum of $first and $second is $((first+second))"

# then run bash addition.sh 2 5  in terminal (first parameter, second parameter)
# bash addition.sh 2 a --- didn't crash, just said it was = 2

# ran 
# duckdb -csv database.db "SELECT Code, Common_name FROM Species"
# in terminal

# see bash as a glue software
# lots of perks to help you
# could use R, Python, etc. beyond duckdb
# https://ucsb-library-research-data-services.github.io/bren-meds213-spring-2024/modules/week05/bash-essentials.html