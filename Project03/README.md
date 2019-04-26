# Fill Up My Cup

## Instructions
1. SSH into the Mac1xa3 server using your choice of command line (I use Windows Powershell)
2. CD into the CS1XA3 repo, then CD into the Project03 Directory (Path should be:~/CS1XA3/Project03)
3. Activate the virtual environment by CD-ing into python_env2 (Path should be:~/CS1XA3/Project03/python_env2)
4. Enter "source bin/activate" followed by return and (python_env2) should be visible at the beginning of the command line ((python_env2) trinhc2@1xa3-server:~/CS1XA3/Project03/python_env2)
5. CD back into the Project03 directory using cd .. (Path should be:~/CS1XA3/Project03)
6. Run the server by CD-ing into django_project (Path should be:~/CS1XA3/Project03/django_project)
7. Enter "python3 manage.py runserver localhost:10056" followed by return. The server should now be running.
8. In the URL of your browser go to https://mac1xa3.ca/u/trinhc2/project3.html and the game should run without any further problems
9. Quit the server by pressing Ctrl + C
10. Deactivate the virtual environment by entering "deactivate" followed by return.

## Features
### Summary of Features Utilized

Client Side: onClick mouse events/notifyTap events, graphics and animation, random number generating, keyboard state events, onInput events, html buttons and text and using stylesheets.

Server Side: get and posts requests, server error handling, page loading, json encoding and decoding, user authentication (login, register, logout), database management (updating data, adding new data, querying data), rendering templates and one to one relations.

* A Game where rain falls from the sky and the objective is to collect as many raindrops as possible. Use the "A" and "D" keys to move left and right and press and hold "J" if you want to move faster (hint: you will have to use J often). You have 3 lives, a life is taken away if a raindrop touches the ground. Login is required to play the game.

* User Authentication: Users are able to create usernames and passwords to save their scores. To register, click on "Create an account" and then enter a username and password. The only limitations are that your username must be unique and your password cannot be empty.

* Score submission: After the game ends the user is able to submit their score to the database by clicking on "Submit Score". There are also local high scores in case the user does not want to submit their score to the server.

* Score retrieval: Before the game starts the user is able to retrieve their high score from the database by clicking "Get Score" located beside the high score in the top left corner. A newly registered user will have default 0 as their high score in the database.

* Leaderboard: On the login screen users are able to view a leaderboard which displays the current high scores by all users. The leaderboard is sorted from highest to lowest.

## References
I referenced https://github.com/NotAProfDalves/elm_django_examples for help with my user authentication django application and for Http posts, decoding, encoding and error handling in elm.

I referenced http://www.learningaboutelectronics.com/Articles/How-to-sort-a-database-table-by-column-with-Python-in-Django.php for help with using the render function and html templates for the leaderboard.

I referenced https://guide.elm-lang.org/effects/random.html for help with randomly generated an X value.

I referenced https://getbootstrap.com/docs/4.3/getting-started/introduction/ for how to use the bootstrap stylesheet

I referenced https://gist.github.com/coreytrampe/a120fac4959db7852c0f for how to load external CSS into elm
