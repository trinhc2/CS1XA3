##Fill Up My Cup

### Instructions
1. SSH into the Mac1xa3 server using your choice of command line (I Use Windows Powershell)
2. CD into the CS1XA3 repo, then CD into the Project03 Directory (Path should be:~/CS1XA3/Project03)
3. Activate the virtual environment by CD-ing into python_env2 (Path should be:~/CS1XA3/Project03/python_env2)
4. Enter "source bin/activate" followed by return and (python_env2) should be visible at the beginning of the command line ((python_env2) trinhc2@1xa3-server:~/CS1XA3/Project03/python_env2)
5. CD back into the Project03 directory using cd .. (Path should be:~/CS1XA3/Project03)
6. Run the server by CD-ing into django_project (Path should be:~/CS1XA3/Project03/django_project)
7. Enter "python3 manage.py runserver localhost:10056" followed by return. The server should now be running.
8. In the URL of your browser go to https://mac1xa3.ca/u/trinhc2/project3.html and the game should run without any further problems
9. Quit the server by pressing Ctrl + C
10. Deactivate the virtual environment by entering "deactivate" followed by return.

### Features
* A Game where rain falls from the sky and the objective is to collect as many raindrops as possible. Use the "A" and "D" keys to move left and right and press and hold "J" if you want to move faster (hint: you will have to use J often). You have 3 lives, a life is taken away if a raindrop touches the ground. Login is required to play the game.

* User Authentication: Users are able to create usernames and passwords to save their scores. To register, click on "Create an account" and then enter a username and password. The only limitations are that your username must be unique and your password cannot be empty.

* Score submission: After the game ends the user is able to submit their score to the database by clicking on "Submit Score". There are also local high scores in case the user does not want to submit their score to the server.

* Score retrieval: Before the game starts the user is able to retrieve their high score from the database by clicking "Get Score" located beside the high score in the top left corner. A newly registered user will have default 0 as their high score in the database

* Leaderboard: On the login screen users are able to view a leaderboard which displays the current high scores by all users. The leaderboard is sorted from highest to lowest
