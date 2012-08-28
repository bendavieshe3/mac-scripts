#!/bin/bash


#required for processing files with spaces
#change default file separator
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

if [ "$#" -gt 0 ]; then
	fbypath="$1"
	files="$1"
else 
	fbypath="./"
	files="./*"
fi

regex=[12]{1}[09]{1}[0-9]{2}

for f in $files
do
	#check to see if filename contains a likely year
	if [[ $f =~ $regex ]]; then
		#find year and determine the year folder
		year=$BASH_REMATCH
		yearFolder=$fbypath/$year
		filename=${f##*/}		

		echo "Processing $f - found $year"

		#make sure this is not a year filing directory
		if [ ! -d $f ] || [[ ! $filename =~ ^$regex ]]; then 

			echo '-- not a file directory'	

			if [ ! -d $yearFolder ]; then
				echo '-- making folder'
				mkdir $yearFolder
			fi
			if [ ! -a $yearFolder/"$f" ]; then

				echo "-- moving $filename"
				mv "$f" "$yearFolder/$filename"
			fi
		else
			echo "-- is a directory"

		fi
	else
		echo "Processing $f - no match"
	fi
done

#restore default file separator
IFS=$SAVEIFS