#!/bin/sh
#Script usage: sh script_logicallis.sh <input_file> <output_file>
zcreate="zonecreate "
quote='"'
comma=','
semicolon=';'
isZone=false
outputstr=''
divlist=''
inputfile=$1
outputfile=$2
echo "Input file:"$inputfile
echo "Output file:"$outputfile
while IFS= read -r line; do
#The pattern is, Zone should start with Z- followed by apha numeric then a hyphen ending with space
#We are matching the third argument hence $3, if argument varies this needs to be changed
zone=$(echo "$line" | awk 'match($3,/Z-+[A-Za-z0-9]+-+[^\s]+/) {print $3}')
if [ ! -z "$zone" ]
then
if [ ! -z "$outputstr" ]
then
outputstr=$outputstr$quote$divlist$quote
echo $outputstr >> $outputfile
outputstr=''
divlist=''
fi
outputstr=$zcreate$quote$zone$quote$comma
#check not empty, if no division then dont print
else
#The pattern here is start with [ then alpha numeric followed by a hyphen and apha-numeric
#the 5th argument is matched hence using the same.
division=$(echo "$line" | awk 'match($5,/\[([A-Za-z0-9]*-[a-zA-Z0-9]*)/) {print $5}')
if [ ! -z "$division" ]
then
if [ ! -z "$divlist" ]
then
divlist=$divlist$semicolon$division
else
divlist=$division
fi
fi
fi
done <$inputfile
if [ ! -z "$outputstr" ]
then
outputstr=$outputstr$quote$divlist$quote
echo $outputstr >> $outputfile
fi
echo "File processed sucessfully!"
