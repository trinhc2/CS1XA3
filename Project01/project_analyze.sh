#!/bin/bash

cd ..

echo "Which functions which you like to execute: 
	1) File Type Count
	2) TODO log
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

if [ $funcNum = "1" ]; then
	echo "Executing File Type Count"
	fileTypeCount

elif [ $funcNum = "2" ]; then
	echo "Executing TODO log"
	todoLog

fi


