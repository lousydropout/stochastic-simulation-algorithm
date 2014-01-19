package body Numerics is
   
   function "+" (Left  : in Natural_Vector;
		 Right : in Int_Vector) return Natural_Vector is
      Result : Natural_Vector (Left'Range);
   begin
      for I in Left'Range loop
	 Result (I) := Natural (Left (I) + Right (I + Right'First - Left'First));
      end loop;
      return Result;
   end "+";

end Numerics;
