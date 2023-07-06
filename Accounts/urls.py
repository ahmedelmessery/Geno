from django.urls import path
from Accounts import views
from django.contrib.auth import views as auth_views


urlpatterns = [
    path('', views.index, name='index'),
    path('home/', views.home, name='home'),
    path('login/', auth_views.LoginView.as_view(template_name='Login.html'), name='login'),
    path('register/', views.register, name='register'),
    path('register.html', views.register, name='register'),
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),
    path('settings/change_password/', auth_views.PasswordChangeView.as_view(
        template_name='change_pass.html'), name='password_change'),
    path('settings/change_password/done', auth_views.PasswordChangeDoneView.as_view(
        template_name='index.html'), name='password_change_done'),

]
