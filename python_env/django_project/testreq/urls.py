from django.urls import path
from . import views

urlpatterns = [
	path('', views.hello , name="testreq-hello"),
	path("gettest/" , views.gettest , name="testreq-gettest"),
]
