from django.shortcuts import render
from django.http import HttpResponse

def hello(request):
	return HttpResponse("Hello")

def gettest(request):
	key  = request.GET
	name = key.get("name","") #second string is if there is nothing returned
	age  = key.get("age","")

	return HttpResponse("Hello " + name + " your " + age + " old")
# Create your views here.
