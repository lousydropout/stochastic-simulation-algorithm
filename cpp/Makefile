CC=g++-4.8

all: stoch

stoch: stoch.o
	$(CC) -std=c++0x stoch.o -o stoch

stoch.o: stoch.cpp
	$(CC)  -std=c++0x -c stoch.cpp

clean:
	rm -rf *~ *.o data*.csv stoch
