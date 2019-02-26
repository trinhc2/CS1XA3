### Features

I selected the following features:
* File Type Count
  * Returns a file count for how many file types exist.
* TODO Log
  * Puts every line with a TODO tag into the file "todo.log"
* Delete Temporary Files
  * Deletes all untracked files with the .tmp extension
* Merge Log
  * Finds the commit hashes where merge is mentioned in the commit message and puts it into the file "merge.log"

### Instructions

1. To run my script, execute it as you would normally (./project_analyze.sh).
2. A list will be outputted displaying the functions available to be executed.
3. You will be prompted to enter a number corresponding to which function you would like to be executed.
 (ex. Enter 1 for File Type Count)
4. Enter the number of the function and hit "Enter".
5. The script will run without further input needed.

### Custom Feature (Size of Folder/File)

My custom feature finds the size of a folder or file.
If the user wants the size of a file, it will return the size of the file.
If the user wants to find the size of a folder, it will return the folder size as well as the largest object in folder.

To use my custom feature:

1. Run the script
2. Enter the number "5"
3. The script will list everything in the current directory
4. Enter the name of the file/folder
5. The script will run by itself
