from cProfile import label
import matplotlib.pyplot as plt

revcvovi=[]
cuda_ukupno = []
velicina = []
server = []
numpy_time = []

if __name__=='__main__':
    k = 0
    f = open("bfs_recovi.txt", "r")
    for line in f:
        if (k==9 or (k>9 and (k-9)%12==0)):
            revcvovi.append(float(line.split()[3]))
        k+=1
    f.close()
    f = open('bfs_times.txt','r')
    for line in f:
        k = line.split()
        cuda_ukupno.append(float(k[3]))
        server.append(float(k[2])/1000000)
        velicina.append(float(k[1]))
        numpy_time.append(float(k[4]))
    for i in range(len(velicina)):
        print(velicina[i],',',server[i],',',cuda_ukupno[i],',',cuda_ukupno[i],',',numpy_time[i])
    plt.plot(velicina,server, label='server')
    plt.plot(velicina,revcvovi,label='server+saobracaj')
    plt.plot(velicina,cuda_ukupno, label='ukupno')
    plt.xlabel('Broj elemenata u nizu')
    plt.ylabel('Vreme izvrsavanja [s]')
    plt.legend()
    plt.title('Zavisnost vremena izvrsavanja mnozenja od broja elemenata u nizu')
    plt.show()
    plt.plot(velicina,cuda_ukupno, label='rtiCUDA')
    plt.plot(velicina,numpy_time,label='numpy')
    plt.title('Zavisnost vremena izvrsavanja mnozenja od broja elemenata u nizu')
    plt.xlabel('Broj elemenata u nizu')
    plt.ylabel('Vreme izvrsavanja [s]')
    plt.legend()
    plt.show()
    