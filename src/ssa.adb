with Numerics, Numerics.Real_Functions, Numerics.Real_Arrays, Numerics.Random;
use  Numerics, Numerics.Real_Functions, Numerics.Real_Arrays, Numerics.Random;
with Ada.Text_IO; use Ada.Text_IO;

procedure SSA is

   subtype Rxn_Range     is Natural range 1 .. 3; -- # of Chemical Reactions
   subtype Species_Range is Natural range 1 .. 2; -- # of Chemical Species
   
   -- Rxn & Initial Coefficients-------------
   C    : constant Real_Vector (Rxn_Range) := (1.0, 0.01, 10.0); 
   Y    : Natural_Vector (Species_Range) := (500, 100); 
   
   -- Define Chemical Reactions -------------
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
	 when 1 => return ( 1,  0);
	 when 2 => return (-1,  1);
	 when 3 => return ( 0, -1);
      end case;
   end ΔY;
   -------------------------------------------
      
   
   -----------------------------------------------------------------
   -- Do not touch the code below -----------
   -----------------------------------------------------------------
   
   procedure Calc_TM (Y	: in     Natural_Vector;
		      C	: in     Real_Vector;
		      τ	:    out Real;
		      μ	:    out Rxn_Range) is
      Sum : Real_Vector (Rxn_Range);
      A0  : Real := 0.0;
      Tmp : Real;
   begin
      -- Calculate A0 & Sum first
      for I in Rxn_Range loop
	 A0      := A0 + Reaction (I, C, Y);
	 Sum (I) := A0;
      end loop;
      -- Calculate τ 
      τ   := Log (1.0 / Rand) / A0;
      -- Calculate μ--
      Tmp := Rand * A0;
      for I in Rxn_Range loop
	 if Tmp <= Sum (I) then
	    μ := I; exit;
	 end if;
      end loop;
      -----------------
   end Calc_TM;
   
   
   package Real_IO is new Ada.Text_IO.Float_IO (Real); use Real_IO;
   package Int_IO is new Ada.Text_IO.Integer_IO (Integer); use Int_IO;
   ------------------------------------------------------------------------
   T_Final : constant Real := 100.0;
   Dt	   : constant Real := 0.001;
   T_Print : Real	   := 0.0;
   Time    : Real          := 0.0;
   τ	   : Real;
   μ	   : Natural;
   F       : File_Type;	-- handle for the output file
   
   EXTINCTION : exception;
   ----------------------------------------------------------------------
   
begin
   
   -- Create output file & set as default output -----
   Create (F, Name => "data.out"); Set_Output (F);
   Put_Line ("t, y1, y2"); -- Print Header
   ----------------------------------------------------
   
   
   while T_Print < T_Final loop
      T_Print := Time + Dt;
      
      while Time < T_Print loop
	 -- SSA ------------------
	 Calc_TM (Y, C, τ, μ);
	 Time := Time + τ; 
	 Y    := Y + ΔY (μ);
	 --------------------------
	 -- Checking for extinction ----
	 for I in Species_Range loop
	    if Y (I) = 0 then raise EXTINCTION; end if;
	 end loop;
	 ------------------------------
      end loop;
      
      -- Print results ----
      Put (Time); Put (", "); 
      Put (Y (1)); Put (", "); 
      Put (Y (2)); New_Line;
      --------------------
   end loop;
   
exception
   
   when EXTINCTION =>
      Set_Output (Standard_Output);
      Put_Line ("One of the species have died out. Ending simulation");
      Put ("Time: "); Put (Time, Aft => 2, Exp => 0); New_Line;
      Put ("Y1: "); Put (Y (1)); New_Line;
      Put ("Y2: "); Put (Y (2)); New_Line;
      
end SSA;
