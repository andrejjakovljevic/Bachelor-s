from cProfile import label
import matplotlib.pyplot as plt

lengths = []
cudas = []
cupy = []

if __name__=='__main__':
    f = open("stats/lu_cupy_stats.txt", "r")
    for x in f:
        niz = x.split(' ')
        lengths.append(float(niz[0]))
        cudas.append(float(niz[1]))
        cupy.append(float(niz[2]))
    plt.plot(lengths,cudas, label='rtiCUDA')
    plt.plot(lengths,cupy, label='CuPy')
    plt.xlabel('Димензија матрице')
    plt.ylabel('Време извршавања [секунде]')
    plt.legend()
    plt.title('Зависност времена раучнања броја троуглова од димензија матрице')
    plt.show()
