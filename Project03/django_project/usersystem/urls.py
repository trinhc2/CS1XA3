from django.urls import path
from . import views

# routed from e/macid/userauthapp/
urlpatterns = [
    path('registeruser/', views.register_user , name = 'usersystem-register_user') ,
    path('loginuser/', views.login_user , name = 'usersystem-login_user') ,
    path('userinfo/', views.user_info , name = 'usersystem-user_info') ,
    path('logoutuser/', views.logout_user , name = 'usersystem-logout_user')
]
