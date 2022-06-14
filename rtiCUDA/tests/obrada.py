from cProfile import label
import matplotlib.pyplot as plt

lengths = []
cupys = []
cudas = []

if __name__=='__main__':
    f = open("stats/cupy_multiply.txt", "r")
    for x in f:
        niz = x.split(' ')
        lengths.append(float(niz[0]))
        cupys.append(float(niz[1]))
    f = open("stats/rtiCUDA_multiply.txt", "r")
    for x in f:
        niz = x.split(' ')
        #lengths.append(float(niz[0]))
        cudas.append(float(niz[1]))
    f.close()
    plt.plot(lengths,cudas, label='rtiCUDA')
    plt.plot(lengths,cupys, label='CuPy')
    plt.xlabel('Број елемената у низу')
    plt.ylabel('Време извршавања [секунде]')
    plt.legend()
    plt.title('Зависност времена извршавања множења од броја елемената у низу')
    plt.show()
