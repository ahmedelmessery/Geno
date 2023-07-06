from django.urls import path
from Prediction import views


urlpatterns = [
    path('home/question1.html', views.prediction, name='prediction'),
    # path('home/question2.html', views.prediction2, name='prediction2'),
    path('geno_prediction', views.geno_prediction, name='geno_prediction'),

]
