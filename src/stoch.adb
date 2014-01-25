with Numerics, Numerics.Real_Arrays, Ada.Text_IO, Numerics.SSA;
use  Numerics, Numerics.Real_Arrays, Ada.Text_IO;

procedure Stoch is
   subtype Rxn_Range     is Natural range 1 .. 3; -- # of Chemical Reactions
   subtype Species_Range is Natural range 1 .. 2; -- # of Chemical Species

   C    : constant Real_Vector (Rxn_Range) := (1.0, 0.01, 10.0); 
   Y    : Natural_Vector (Species_Range)   := (500, 500); 
   
   ----
   function Reaction (I	: in Rxn_Range;
		      C	: in Real_Vector;
		      Y	: in Natural_Vector) return Real is
   begin
      case I is
	 when 1 => return C (1) * Real (10 * Y (1));
	 when 2 => return C (2) * Real (Y (1) * Y (2));
	 when 3 => return C (3) * Real (Y (2));
      end case;
   end Reaction;
   ----
   function ΔY (I : in Rxn_Range) return Int_Vector is
   begin
      case I is
	 when 1 => return (1,  0);
	 when 2 => return (-1, 1);
	 when 3 => return (0, -1);
      end case;
   end ΔY;
   -------------------------------------------
   package SSA is new Numerics.SSA (Rxn_Range     => Rxn_Range,
				    Species_Range => Species_Range,
				    Reaction      => Reaction,
				    ΔY            => ΔY); use SSA;
   ------------------------------------------------------------------------
   T_Final   : constant Real := 100.0;
   Δt        : constant Real := 0.01;
   T_Print   : Real          := 0.0;
   Time      : Real          := 0.0;
   F         : File_Type;    -- handle for the output file
   EXTINCTION : exception;
begin
   -- Create output file & set as default output -----
   Create (F, Name => "data.out"); 
   Set_Output (F);
   ----------------------------------------------------
   
   Print_Header (Time, Y); -- Print Header
   
   for I in 1 .. Integer (T_Final / Δt) loop
      
      while Time < Real (I) * Δt loop
	 Update (Y, C, Time);
	 if Extinctp (Y) then raise EXTINCTION; end if;
      end loop;
      
      Print_CSV (100.0 * Time, Y); -- Print results
   end loop;
   
exception
   
   when EXTINCTION =>
      Put_Line (Standard_Output, 
		"One of the species have died out. Ending simulation");
end Stoch;
