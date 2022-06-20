from cProfile import label
import matplotlib.pyplot as plt

lengths = []
cudas = []
cupy = []

if __name__=='__main__':
    f = open("stats/cupy_bfs.txt", "r")
    for x in f:
        niz = x.split(' ')
        lengths.append(float(niz[1]))
        cudas.append(float(niz[2]))
        cupy.append(float(niz[3]))
    plt.plot(lengths,cudas, label='rtiCUDA')
    plt.plot(lengths,cupy, label='CuPy')
    plt.xlabel('Димензија матрице')
    plt.ylabel('Време извршавања [секунде]')
    plt.legend()
    plt.title('Зависност времена извршавања алгоритма од димензија матрице')
    plt.show()
