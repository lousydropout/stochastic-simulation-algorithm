with Ada.Numerics.Float_Random; 

package Numerics.Random is
   function Rand return Real;
   
   Seed : Ada.Numerics.Float_Random.Generator;
end Numerics.Random;
