with Numerics, Numerics.Real_Arrays, Ada.Text_IO, Numerics.SSA;
use  Numerics, Numerics.Real_Arrays, Ada.Text_IO;

procedure Stoch is
   package Int_IO  is new Ada.Text_IO.Integer_IO (Integer); use Int_IO;
   subtype Rxn_Range     is Natural range 1 .. 3; -- # of Chemical Reactions
   subtype Species_Range is Natural range 1 .. 2; -- # of Chemical Species

   C    : constant Real_Vector (Rxn_Range)          := (1.0, 0.01, 10.0); 
   Y_0  : constant Natural_Vector (Species_Range)   := (500, 100); 
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
				    ΔY            => ΔY); 
   use SSA;
   
   ------------------------------------------------------------------------
   type File_Vector is array (Integer range <>) of File_Type;
   
   T_Final   : constant Real  := 3.0;
   Δt        : constant Real  := 1.0;
   Time      : Real           := 0.0;
   T_Print   : Real_Vector (1 .. Integer (T_Final / Δt));
   
   F         : File_Type;     -- handler for the output file
   F_Print   : File_Vector (1 .. Integer (T_Final / Δt));
   
   Y         : Natural_Vector := Y_0;
   
   τ         : Real;
   μ         : Rxn_Range;
   Counter   : Natural := 1;
   
begin
   
   for I in T_Print'Range loop
      T_Print (I) := Real (I) * Δt;
      Create (File => F_Print (I), 
	      Name => "data" + I'Img + ".csv");
      Print_Header (File => F_Print (I),
		    Item => Y); 
      
      --  Open (File => F_Print (I), 
      --  	    Mode => Append_File, 
      --  	    Name => "data" + I'Img + ".csv");
   end loop;
   
   
   for J in 1 .. 10_000 loop   
      Put ("Iteration: "); Put (J, 0); New_Line;
      
      -- Initialization & Reinitialization ------
      Y       := Y_0;
      Time    := 0.0;
      Counter := 1;
      ------------------------------------------
      
      -- SSA -----------------------------------
      while Time <= T_Final loop
	 Calc_Tau_Mu (Y, C, τ, μ);
	 
	 if Counter in T_Print'Range and then Time + τ > T_Print (Counter) then
	    Print_CSV (File => F_Print (Counter), 
		       Item => Y);
	    Counter := Counter + 1;
	 end if;
	 
	 Time := Time + τ; 
	 Y    := Y + ΔY (μ);
	 
	 exit when  Extinctp (Y);
      end loop;
      ------------------------------------------
   end loop;

end Stoch;
