#!/bin/bash

cd ..

echo "Which functions which you like to execute: 
	1) File Type Count
Enter a Number followed by the Enter key."

read funcNum

fileTypeCount () {

haskell=$(find . -iname "*.hs" | wc -l)
html=$(find . -iname "*.html" | wc -l)
bash=$(find . -iname "*.sh" | wc -l)
python=$(find . -iname "*.py" | wc -l)
java=$(find . -iname "*.js" | wc -l)
css=$(find . -iname "*.css" | wc -l)

echo "HTML: $html, Javascript: $java, CSS: $css, Python: $python, Bash: $bash, Haskell: $haskell"

}

if [ $funcNum = "1" ]; then
	echo "Executing File Type Count"
	fileTypeCount

fi
