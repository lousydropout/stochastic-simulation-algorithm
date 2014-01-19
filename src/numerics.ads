package Numerics is
   type Real is new Long_Float range Long_Float'First .. Long_Float'Last;
   type Int_Vector is array (Integer range <>) of Integer;
   type Natural_Vector is array (Integer range <>) of Natural;

   function "+" (Left  : in Natural_Vector;
		 Right : in Int_Vector) return Natural_Vector;

end Numerics;
