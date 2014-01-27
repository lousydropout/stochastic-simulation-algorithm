#include <cstdlib>
#include <time.h>
#include "random_number_generator.h"


float randf()
{
  return float(rand()) / float(RAND_MAX);
}


void seed()
{
  time_t seconds;
  time(&seconds);
  srand((unsigned int) seconds);
}
