from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
import json

from .models import UserInfo

def register_user(request):
    """recieves a json request { 'username' : 'val0', 'password' : 'val1' } and saves it
       it to the database using the django User Model
       Assumes success and returns an empty Http Response"""

    json_req = json.loads(request.body)
    uname = json_req.get('username','')
    passw = json_req.get('password','')

    if uname != '':
        user = User.objects.create_user(username=uname,
                                        password=passw)

        userinfo = UserInfo.objects.create(user=user, info=0)

        login(request,user)
        return HttpResponse('LoggedIn')

    else:
        return HttpResponse('LoggedOut')


def signin_user(request):
    """recieves a json request { 'username' : 'val0' : 'password' : 'val1' } and
       authenticates and loggs in the user upon success """
    json_req = json.loads(request.body)
    uname = json_req.get('username','')
    passw = json_req.get('password','')

    user = authenticate(request,username=uname,password=passw)
    if user is not None:
        login(request,user)
        return HttpResponse("LoggedIn")
    else:
        return HttpResponse('LoginFailed')

def logout_user(request):
    logout(request)
    return HttpResponse("LoggedOut")

def submit_user(request):
    json_req = json.loads(request.body)
    uinfo = json_req.get('info','')
    uname = json_req.get('username','')

    updateUser = UserInfo.objects.get(user__username=uname)
    updateUser.info = uinfo
    updateUser.save()
    return HttpResponse("Success")

def getscore_user(request):
    json_req = json.loads(request.body)
    uname = json_req.get('username','')
    getUser = UserInfo.objects.get(user__username=uname)

    return JsonResponse({"info" : getUser.info})

def getleaderboard(request):

    #gets all objects of the Toy database unsorted

    # gets all objects of the Toy database sorted by price
    sortedscore= UserInfo.objects.order_by('info').reverse()

    context= {'sortedscore': sortedscore}

    return render(request, 'leaderboard.html', context)



def user_info(request):
    """serves content that is only available to a logged in user"""

    if not request.user.is_authenticated:
        return HttpResponse("LoggedOut")
    else:
        # do something only a logged in user can do
        return HttpResponse("Hello " + request.user.first_name)
