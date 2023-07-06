from django.urls import path
from Analysis import views


urlpatterns = [
    path('home/haploview.html', views.haploview, name='haploview'),
    path('home/popgene.html', views.popgene, name='popgene'),
    # path('geno_prediction', views.geno_prediction, name='geno_prediction),

]
