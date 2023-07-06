from django.shortcuts import render

# Create your views here.


def haploview(request):
    return render(request, 'haploview.html')


def popgene(request):
    return render(request, 'popgene.html')
