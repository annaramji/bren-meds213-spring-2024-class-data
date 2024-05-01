#!/bin/bash


# get bash to do math with $((math+here))
# note: () means command
# (()) means do this operation?

# $1 is first parameter, $2 is second, etc.

first=$1
second=$2

echo "The sum of $first and $second is $((first+second))"

# then run bash addition.sh 2 5  in terminal (first parameter, second parameter)
# bash addition.sh 2 a --- didn't crash, just said it was = 2
