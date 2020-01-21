CC=g++-4.8

all: stoch

random_number_generator.o: random_number_generator.cpp
	$(CC) -c random_number_generator.cpp

stoch: stoch.o random_number_generator.o
	$(CC) -std=c++0x stoch.o random_number_generator.o -o stoch

stoch.o: stoch.cpp
	$(CC)  -std=c++0x -c stoch.cpp

clean:
	rm -rf *~ *.o data*.csv stoch
