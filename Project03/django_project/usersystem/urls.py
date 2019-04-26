from django.urls import path
from . import views

# routed from e/trinhc2/usersystem/
urlpatterns = [
    path('registeruser/', views.register_user , name = 'usersystem-register_user') ,
    path('signinuser/', views.signin_user , name = 'usersystem-signin_user') ,
    path('savescore/', views.submit_user, name = 'usersystem-submit_user'),
    path('getscore/', views.getscore_user, name = 'usersystem-get_user'),
    path('getleaderboard/', views.getleaderboard, name = 'usersystem-getleaderboard'),
    path('logoutuser/', views.logout_user, name = 'usersystem-logout_user')

]
