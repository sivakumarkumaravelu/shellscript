#!/bin/sh
#Script usage: sh script_lcls.sh <input_file> <output_file>
zcreate="zonecreate "
quote='"'
comma=','
semicolon=';'
isZone=false
divisionlist=''
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
isZone=true
if [ "$isZone" = true ] 
then
#trim the last character
divisionlist=${divisionlist%?}
command=$zcreate$quote$zone$quote$comma$quote$divisionlist$quote
fi
#check not empty, if no division then dont print
if [ ! -z "$divisionlist" ]
then
echo $command >> $outputfile
divisionlist=''
fi
else
echo $line
#The pattern here is start with [ then alpha numeric followed by a hyphen and apha-numeric
#the 5th argument is matched hence using the same.
division=$(echo "$line" | awk 'match($5,/\[([A-Za-z0-9]*-[a-zA-Z0-9]*)/) {print $5}')
if [ ! -z "$division" ]
then
divisionlist=$divisionlist$division$semicolon
isZone=false
fi
fi
done <$inputfile
echo "File processed sucessfully!"
