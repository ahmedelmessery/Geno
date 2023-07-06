from django.shortcuts import render, redirect
import pickle
import numpy as np

# Create your views here.


def prediction(request):
    return render(request, 'question1.html')


def geno_prediction(request):
    try:
        l1 = 0
        l2 = 0
        m1 = 0
        m2 = 0
        p1 = 0
        p2 = 0
        p3 = 0
        q1 = 0
        q2 = 0
        q3 = 0
        u1 = 0
        u2 = 0
        u3 = 0
        u4 = 0
        # global l1, l2, m1, m2, p1, p2, p3, q1, q2, q3, u1, u2, u3, u4
        if request.method == 'POST':
            a = request.POST['a']
            b = request.POST['b']
            c = request.POST['c']
            e = request.POST['e']
            f = request.POST['f']
            g = request.POST['g']
            h = request.POST['h']
            i = request.POST['i']
            j = request.POST['j']
            k = request.POST['k']
            l = request.POST['l']
            if l == 'Female':
                l1 = 1
                l2 = 0
            elif l == 'Male':
                l1 = 0
                l2 = 1
            elif l == 'I perfer not to answer':
                l1 = 0
                l2 = 0
            m = request.POST['m']
            if m == 'No':
                m1 = 1
                m2 = 0
            elif m == 'Yes':
                m1 = 0
                m2 = 1
            elif m == 'Not available':
                m1 = 0
                m2 = 0
            n = request.POST['n']
            o = request.POST['o']
            p = request.POST['p']
            if p == 'No':
                p1 = 1
                p2 = 0
                p3 = 0
            elif p == 'Not aplicable':
                p1 = 0
                p2 = 1
                p3 = 0
            elif p == 'Yes':
                p1 = 0
                p2 = 0
                p3 = 1
            q = request.POST['q']
            if q == 'No':
                q1 = 1
                q2 = 0
                q3 = 0
            elif q == 'Not aplicable':
                q1 = 0
                q2 = 1
                q3 = 0
            elif q == 'Yes':
                q1 = 0
                q2 = 0
                q3 = 1
            r = request.POST['r']
            s = request.POST['s']
            t = request.POST['t']
            u = request.POST['u']
            if u == 'Inconclusive':
                u1 = 1
                u2 = 0
                u3 = 0
                u4 = 0
            elif u == 'Normal':
                u1 = 0
                u2 = 1
                u3 = 0
                u4 = 0
            elif u == 'Slightly Abnormal':
                u1 = 0
                u2 = 0
                u3 = 1
                u4 = 0
            elif u == 'Abnormal':
                u1 = 0
                u2 = 0
                u3 = 0
                u4 = 1

            input_data1 = np.array([[a, b, c, e, f, g, h, i,
                                    j, k, l1, l2, m1, m2, n, o, p1, p2, p3, q1, q2, q3, r, s, t, u1, u2, u3, u4]])

            # input_data = [[0, 1, 0, 0, 1, 0, 1, 0,
            #                0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0]]

            with open(r'C:\Users\YN\OneDrive\Desktop\final_project - Copy\final_project - Copy\Prediction\genetic_disorder.sav', 'rb') as myfile1:
                model1 = pickle.load(myfile1)
                result1 = model1.predict(input_data1)
                result1 = float(result1)

            input_data2 = np.array([[a, b, c, e, result1, f, g, h, i,
                                    j, k, l1, l2, m1, m2, n, o, p1, p2, p3, q1, q2, q3, r, s, t, u1, u2, u3, u4]])

            with open(r'C:\Users\YN\OneDrive\Desktop\final_project - Copy\final_project - Copy\Prediction\genetic_disorder_subclass.sav', 'rb') as myfile2:
                model2 = pickle.load(myfile2)
                result2 = model2.predict(input_data2)
                result2 = float(result2)

            # model = pickle.load(
            #     open(r'C:\Users\Nadee\Desktop\final_project - Copy\Prediction\genetic_disorder.sav', 'rb'))

            return render(request, 'geno_prediction.html', {'result1': result1, 'result2': result2})
        else:
            return redirect('home')
    except:
        return render(request, 'error.html')
