#!/bin/bash

cd ..

echo "Which functions which you like to execute: 
	1) File Type Count
	2) TODO log
	3) Delete Temporary Files
	4) Merge Log
	5) Size of Folder/File
Enter a Number followed by the Enter key."

read funcNum

fileTypeCount () {

#finds files with the following extensions and returns the number of files with the corresponding extension
haskell=$(find . -iname "*.hs" | wc -l)
html=$(find . -iname "*.html" | wc -l)
bash=$(find . -iname "*.sh" | wc -l)
python=$(find . -iname "*.py" | wc -l)
java=$(find . -iname "*.js" | wc -l)
css=$(find . -iname "*.css" | wc -l)

echo "HTML: $html, Javascript: $java, CSS: $css, Python: $python, Bash: $bash, Haskell: $haskell"

}

todoLog () {

#searches for lines in every file with the tag TODO, piped into a reverse grep because this line of code will appear
#in the log aswell
grep --exclude=todo.log -rn "#TODO" | grep -v '"#TODO"' > todo.log

}

deleteTmp () {

#lists untracked files, finds files with the .tmp extension and removes it
git ls-files . --exclude-standard --others | find . -name "*.tmp" | xargs rm

}

mergeLog () {

#looks for the line with merge and adds the has to merge.log
git log --oneline | grep -i "merge" | cut -d ' ' -f1 > merge.log

}

sizeOfF () {

echo "What would you like to find the size of?"

#outputs the names of the files and folders in the current directory
ls -1

echo "Enter the name of the file/folder (case sensitive) followed by the Enter key"
read fname

#if a file is inputted
if [ -f $fname ]; then
	#stores the first column in a variable (the first row contains the size of the folder/file)
	fsize=$(du -h "$fname" | cut -f1)
	echo "The size of $fname is $fsize"

#if a directory is inputted
elif [ -d $fname ]; then
	fsize=$(du -h "$fname" | cut -f1)
	echo "the size of $fname is $fsize"
	cd $fname

	#finds the size of everything in the directory, sorts the first column, takes the 2nd last entry because the last entry is the sub-directory itself
	largestFileSize=$(du -ah | sort -k1n | cut -f1 | tail -2 | head -1)

	#same as before except we cut the second column to get the names of everything, we cut the first 2 letters because they start with ./
	largestFName=$(du -ah | sort -k1n | cut -f2 | tail -2 | head -1 | cut -c3-)

	#if the object in the directory is a file
	if [ -f $largestFileName ]; then
		echo "The largest object in $fname is the file $largestFName ($largestFileSize)"

	#if the object in the directory is a directory
	elif [ -d $largestFileName ]; then
		echo "The largest object in $fname is the folder $largestFName ($largestFileSize)"

	fi

else
	echo "Invalid input"

fi

}

if [ $funcNum = "1" ]; then
	echo "Executing File Type Count"
	fileTypeCount

elif [ $funcNum = "2" ]; then
	echo "Executing TODO log"
	todoLog

elif [ $funcNum = "3" ]; then
	echo "Deleting Temporary Files"
	deleteTmp

elif [ $funcNum = "4" ]; then
	echo "Creating Merge Log"
	mergeLog

elif [ $funcNum = "5" ]; then
	sizeOfF

else
	echo "Invalid input"

fi


