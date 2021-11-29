#!/bin/bash
#shell script to reverse a inputed string and show it.

echo -n "enter the string u want to reverse:-"
read string
len=${#string}
echo "no of character is: $len"
while test $len -gt 0
do
rev=$rev`echo $string |cut -c $len`
len=`expr $len - 1`
done
echo "the reverse string is: $rev "
