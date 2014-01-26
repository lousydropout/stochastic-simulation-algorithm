#include <iostream>
#include <fstream>
#include <cstdlib>
#include <time.h>
#include <math.h>
#include <string>
using namespace std;

const int N_chem = 2;
const int N_rxn = 3;
const int y_0[N_chem] = {500, 100};
const float c[N_rxn] = {1.0, 0.01, 10.0};
int y[N_chem] = {500, 100};

float reaction(int i, const float c[], int y[])
{
  if (i == 1) {
    return c[0] * 10.0 * (float) y[0];
  } else if (i ==2 ) {
    return c[1] * (float) (y[0] * y[1]);
  } else {
    return c[2] * (float) y[1];
  }
}


void dY(int i, int delta[])
{
  if (i == 1) {
    delta[0] = 1; delta[1] = 0;
  } else if (i == 2) {
    delta[0] = -1; delta[1] = 1;
  } else {
    delta[0] = 0; delta[1] = -1;
  }
}



float random(float x)
{
  return x * float(rand()) / float(RAND_MAX);
}

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


float calc_a0(int y[], const float c[])
{
  float a0 = 0.0;
  for(int i = 0; i < N_rxn; i++) {
      a0 += reaction(i, c, y);
  }
  return a0;
}

float calc_tau(float a0, int y[], const float c[])
{
  return log(1.0 / randf()) / a0;
}


int calc_mu(float a0, int y[])
{
  float tmp = randf() * a0;
  float s[N_rxn];
  float a;
  int mu;
  for(int i = 0; i < N_rxn; i++) {
    a += reaction(i, c, y);
    s[i] = a;
  }
  for(int i = 0; i < N_rxn; i++) {
    if (tmp <= s[i]) {
      mu = i;
      break;
    }
  }
  return mu;
}




int main()
{
  const float t_final = 3.0;
  const float dt = 1.0;
  const int N_time = (int) t_final / dt;
  float time = 0.0;
  float tau, a0;
  int mu;
  int delta[N_chem];
  int counter = 0;
  float t_print[N_time];
  ofstream myfile[N_time];
  seed();
  
  for (int i = 0; i < N_time; i++) {
    t_print[i] = dt * (float) (i + 1); // Setting up print times
    // Creating files
    myfile[i].open( "data" + to_string(i + 1) + ".csv");
    myfile[i] << "y1";
    for (int j = 2; j <= N_chem; j++)
      myfile[i] << ", y" + to_string(j);
    myfile[i] << endl;
  }



  for (int i = 1; i <= 1000; i++) {
    cout << "Iteration: " << i << endl;
    // Reinitializing
    counter = 0;
    time = 0.0;
    for (int n = 0; n < N_chem; n++) {
      y[n] = y_0[n];
    }
    while (time < t_final) {
      // Calculating tau & mu
      a0  = calc_a0(y, c);
      tau = calc_tau(a0, y, c);
      mu  = calc_mu(a0, y);
      time += tau;
      ///////////////////////////////
      if (counter < N_time && time > t_print[counter])
	{
	  myfile[counter] << to_string(y[0]);
	  for (int j = 1; j < N_chem; j++)
	    myfile[counter] << ", " + to_string(y[j]);
	  myfile[counter] << endl;
	  counter += 1;
      }
      dY(mu, delta);
      for (int k = 0; k < N_chem; k++)
	{
	  y[k] += delta[k];
	  if (y[k] == 0.0) goto here;
	}
    }
  here: cout << "";
  }

}
