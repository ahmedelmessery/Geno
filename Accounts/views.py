from django.shortcuts import render, redirect, HttpResponseRedirect
from django.contrib.auth import authenticate, login, logout
from .forms import RegisterForm
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.contrib.auth.forms import AuthenticationForm


# Create your views here.


def index(request):
    return render(request, 'index.html')


@login_required
def home(request):
    return render(request, 'Home.html')


def register(request):
    try:
        form = RegisterForm()
        if request.method == 'POST':
            form = RegisterForm(request.POST)
            if form.is_valid():
                user = form.save()
                messages.success(request, 'Account Created successfully!')
                login(request, user)
                return redirect('home')
            else:
                messages.success(
                    request, '''check your error: 1.enter a valid email. 2.Your password can’t be only numeric must contain characters,at least 8 characters''')
                return render(request, 'error.html')
        return render(request, 'register.html', {'form': form})
    except:
        return render(request, 'error.html')


def log_in(request):
    try:
        if not request.user.is_authenticated:
            if request.method == "POST":
                form = AuthenticationForm(request=request, data=request.POST)
                if form.is_valid():
                    username = form.cleaned_data['username']
                    password = form.cleaned_data['password']
                    user = authenticate(username=username, password=password)
                    if user is not None:
                        login(request, user)
                        messages.success(request, 'Logged in successfully!')
                        return HttpResponseRedirect('/home/')
                    else:
                        return render(request, 'error.html')
                else:
                    return render(request, 'error.html')
            else:
                form = AuthenticationForm()
            return render(request, 'Login.html', {'form': form})
        else:
            return HttpResponseRedirect('/home/')
    except:
        return render(request, 'error.html')


def log_out(request):
    logout(request)
    return HttpResponseRedirect('/')


# def user_profile(request):
#     if request.user.is_authenticated:
#         return render(request,'enroll/profile.html',{'name':request.user})
#     else:
#         return HttpResponseRedirect('/login/')
