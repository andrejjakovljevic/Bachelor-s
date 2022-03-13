from cProfile import label
import matplotlib.pyplot as plt

revcvovi=[]
cuda_ukupno = []
velicina = []
server = []
numpy_time = []

if __name__=='__main__':
    k = 0
    f = open("LU_recvovi.txt", "r")
    for line in f:
        if (k==9 or (k>9 and (k-9)%12==0)):
            revcvovi.append(float(line.split()[3]))
        k+=1
    f.close()
    f = open('LU_times.txt','r')
    for line in f:
        k = line.split()
        cuda_ukupno.append(float(k[2]))
        server.append(float(k[1])/1000000)
        velicina.append(float(k[0]))
        numpy_time.append(float(k[3]))
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
    plt.scatter(velicina,cuda_ukupno, label='rtiCUDA')
    plt.scatter(velicina,numpy_time,label='numpy')
    plt.title('Zavisnost vremena izvrsavanja mnozenja od broja elemenata u nizu')
    plt.xlabel('Broj elemenata u nizu')
    plt.ylabel('Vreme izvrsavanja [s]')
    plt.legend()
    plt.show()
    