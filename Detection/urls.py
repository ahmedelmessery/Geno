from django.urls import path
from Detection import views


urlpatterns = [
    path('home/detection.html', views.detection, name='detection'),
    path('geno_detection', views.geno_detection, name='geno_detection'),

]
