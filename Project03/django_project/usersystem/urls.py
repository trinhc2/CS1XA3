from django.urls import path
from . import views

# routed from e/trinhc2/usersystem/
urlpatterns = [
    path('registeruser/', views.register_user , name = 'usersystem-register_user') ,
    path('signinuser/', views.signin_user , name = 'usersystem-login_user') ,
    path('userinfo/', views.user_info , name = 'usersystem-user_info') ,
    path('logoutuser/', views.logout_user , name = 'usersystem-logout_user')
]
