from cProfile import label
import matplotlib.pyplot as plt

lengths = []
cudas = []
numpi = []

if __name__=='__main__':
    f = open("int_test_mul_array.txt", "r")
    for x in f:
        niz = x.split(' ')
        lengths.append(float(niz[0]))
        cudas.append(float(niz[1]))
        numpi.append(float(niz[2]))
    plt.plot(lengths,cudas, label='rtiCUDA')
    plt.plot(lengths,numpi, label='numpy')
    plt.xlabel('Broj elemenata u nizu')
    plt.ylabel('Vreme izvrsavanja [s]')
    plt.legend()
    plt.title('Zavisnost vremena izvrsavanja mnozenja od broja elemenata u nizu')
    plt.show()
