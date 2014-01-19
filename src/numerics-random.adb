package body Numerics.Random is
   
   function Rand return Real is
      Result : Float := Ada.Numerics.Float_Random.Random (Seed);
      -- Built-in function produces floats only
   begin
      return Real (Result);
   end Rand;
   
begin
   
   Ada.Numerics.Float_Random.Reset (Seed);
end Numerics.Random;
