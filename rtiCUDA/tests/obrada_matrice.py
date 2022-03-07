from cProfile import label
import matplotlib.pyplot as plt

lengths = []
cudas = []
numpi = []

if __name__=='__main__':
    f = open("help.txt", "r")
    for x in f:
        niz = x.split(' ')
        lengths.append(float(niz[1]))
        cudas.append(float(niz[3]))
        numpi.append(float(niz[4]))
    plt.scatter(lengths,cudas, label='rtiCUDA')
    plt.scatter(lengths,numpi, label='numpy')
    plt.xlabel('Dimenzija matrice')
    plt.ylabel('Vreme izvrsavanja [s]')
    plt.legend()
    plt.title('Zavisnost vremena racunanja broja trouglova od dimenzija matrice u nizu')
    plt.show()
