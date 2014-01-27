#include <iostream>
#include <fstream>
#include <math.h>
#include <string>
#include "random_number_generator.h"
using namespace std;

/*********************************************************/
// This section defines the chemical reactions

const int N_chem      = 2;
const int N_rxn       = 3;
const int y_0[N_chem] = {500, 100};
const float c[N_rxn]  = {1.0, 0.01, 10.0};
int y[N_chem]         = {500, 100};

float reaction(int i, const float c[], int y[])
{
  if (i == 1) {
    return c[0] * 10.0 * (float) y[0];
  } else if (i == 2) {
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

/***************************************************************/
// The equation numbers refer to Gillespie's "Exact Simulation of Coupled Chemical Reactions" paper
float calc_tau(int y[], const float c[]) // Equation 21a
{
  float a0 = 0;
  for(int i = 0; i < N_rxn; i++) {
    a0 += reaction(i, c, y);
  }
  return log(1.0 / randf()) / a0;
}

int calc_mu(int y[], const float c[]) // Equation 21b
{
  float tmp, a0 = 0.0;
  float s[N_rxn];
  for(int i = 0; i < N_rxn; i++) {
    a0 += reaction(i, c, y);
    s[i] = a0;
  }
  tmp = randf() * a0;
  for(int i = 0; i < N_rxn; i++)
    if (tmp <= s[i]) return i;
  return (N_rxn - 1);
}
/***************************************************************/





int main()
{
  
  const float t_final = 3.0;
  const float dt = 1.0;
  float time;
  
  const int N_time = (int) (t_final / dt);  // # of time steps for data output
  float t_print[N_time];                // array of time steps for data output
  int   counter;  // a counter for iterating through the data output files
  int   delta[N_chem];  // dY -- change in population vector
  
  
  /**** Variables used in SSA *****/
  float tau, a0;
  int   mu;
  /*******************************/
  ofstream myfile[N_time];  // Output files
  seed();   // seed the random number generator



  /***** Create Data Files ********************/
  for (int i = 0; i < N_time; i++)
    {
      t_print[i] = dt * (float) (i + 1); // Setting up print times
      // Creating data files
      myfile[i].open( "data" + to_string(i + 1) + ".csv");
      myfile[i] << "y1";
      for (int j = 2; j <= N_chem; j++)
	{
	  myfile[i] << ", y" + to_string(j);
	}
      myfile[i] << endl;
    }
  /*******************************************/


  // SSA starts here
  for (int i = 1; i <= 1000; i++)
    {
      cout << "Iteration: " << i << endl;
      /*** Initialization & Reinitialization ********************/
      counter = 0;
      time    = 0.0;
      for (int n = 0; n < N_chem; n++) y[n] = y_0[n];
      /****************************************/
      
      while (time < t_final)
	{
	  /** Calculating tau & mu ***************/
	  //    The equation numbers refer to Gillespie's
	  //    "Exact Simulation of Coupled Chemical Reactions" paper
	  tau = calc_tau(y, c);    // Equation 21a
	  mu  = calc_mu(y, c);     // Equation 21b
	  /***************************************/

	  time += tau; // Update time

	  /** Output data **/
	  if (counter < N_time && time >= t_print[counter])
	    {
	      myfile[counter] << to_string(y[0]);
	      for (int j = 1; j < N_chem; j++)
		myfile[counter] << ", " + to_string(y[j]);
	      myfile[counter] << endl;
	      counter += 1;
	    }
	  /***************/

	  /** Update population vector y ****************/
	  dY(mu, delta);
	  for (int k = 0; k < N_chem; k++)
	    {
	      y[k] += delta[k];
	      if (y[k] == 0.0) goto here;  // End path simulation if
	                                   // any specie dies off
	    }
	  /****************************************/
	}
    here: cout << ""; // Does nothing, just need the goto statement
    }
}
