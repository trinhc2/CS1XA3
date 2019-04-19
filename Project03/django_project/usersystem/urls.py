from django.urls import path
from . import views

# routed from e/macid/userauthapp/
urlpatterns = [
    path('adduser/', views.register_user , name = 'usersystem-register_user') ,
    path('loginuser/', views.login_user , name = 'usersystem-login_user') ,
    path('userinfo/', views.user_info , name = 'usersystem-user_info') ,
]
