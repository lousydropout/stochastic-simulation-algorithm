CC=g++
SRC=src

all: stoch

random_number_generator.o: $(SRC)/random_number_generator.cpp
	$(CC) -c $(SRC)/random_number_generator.cpp

stoch: stoch.o random_number_generator.o
	$(CC) -std=c++0x stoch.o random_number_generator.o -o stoch
	rm -rf *~ *.o

stoch.o: $(SRC)/stoch.cpp
	$(CC)  -std=c++0x -c $(SRC)/stoch.cpp

clean:
	rm -rf *~ *.o data*.csv stoch
