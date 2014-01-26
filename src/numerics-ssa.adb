with Numerics.Real_Functions, Numerics.Random, Ada.Text_IO;
use Numerics.Real_Functions, Numerics.Random, Ada.Text_IO;

package body Numerics.SSA is
   
   package Real_IO is new Ada.Text_IO.Float_IO (Real); use Real_IO;
   package Int_IO  is new Ada.Text_IO.Integer_IO (Integer); use Int_IO;
   
   procedure Print_CSV (File : in File_Type;
			τ    : in Real;
			Item : in Natural_Vector) is
   begin
      Put (File, τ);
      for I in Item'Range loop
	 Put (File, ", ");
	 Put (File, Item (I), Width => 0);
      end loop;
      New_Line (File);
   end Print_CSV;
   
      
   procedure Print_CSV (File : in File_Type;
			Item : in Natural_Vector) is
   begin
      Put (File, Item (Item'First), Width => 0);
      for I in Item'First + 1 .. Item'Last loop
	 Put (File, ", ");
	 Put (File, Item (I), Width => 0);
      end loop;
      New_Line (File);
   end Print_CSV;
   
      
   procedure Print_CSV (τ    : in Real;
			Item : in Natural_Vector) is
   begin
      Print_CSV (Standard_Output, τ, Item);
   end Print_CSV;

   
   procedure Print_Header (τ    : in Real;
			   Item : in Natural_Vector) is
   begin
      Put ("t");
      for I in Item'Range loop
	 Put (", y"); 
	 Int_IO.Put (I, Width => 0);
      end loop;
      New_Line;
   end Print_Header;
   
   
   procedure Print_Header (File : in File_Type;
			   Item : in Natural_Vector) is
   begin
      Put (File, "y1"); 
      for I in Item'First + 1 .. Item'Last loop
	 Put (File, ", y"); 
	 Int_IO.Put (File, I, Width => 0);
      end loop;
      New_Line (File);
   end Print_Header;
   
   
   procedure Calc_TM (Y	: in     Natural_Vector;
		      C	: in     Real_Vector;
		      τ	:    out Real;
		      μ	:    out Rxn_Range) is
      S   : Real_Vector (C'Range);
      A0  : Real := 0.0;
      Tmp : Real;
   begin
      -- Calculate A0 & Sum first
      for I in C'Range loop
      	 A0    := A0 + Reaction (I => Rxn_Range (I), 
				 C => C, 
				 Y => Y);
      	 S (I) := A0;
      end loop;
      τ   := Log (1.0 / (Rand + 1.0e-20)) / A0; -- Calculate τ 
      Tmp := Rand * A0; -- Calculate μ--
      for I in C'Range loop
      	 if Tmp <= S (I) then
      	    μ := Rxn_Range (I); 
	    exit;
      	 end if;
      end loop;
      -----------------
   end Calc_TM;

   
   procedure Update (Y	  : in out Natural_Vector;
		     C	  : in     Real_Vector;
		     Time : in out Real) is
      τ : Real;
      μ : Natural;
   begin
      -- SSA ------------------
      Calc_TM (Y => Y, C => C, τ => τ, μ => Rxn_Range (μ));
      Time := Time + τ; 
      Y    := Y + ΔY (Rxn_Range (μ));
      --------------------------
      ------------------------------
      if Extinctp (Y) then raise EXTINCTION; end if;
   end Update;

      
   function Extinctp (Y	: in Natural_Vector) return Boolean is
   begin
      for I in Y'Range loop
	 if Y (I) = 0 then 
	    return True;
	 end if;
      end loop;
      return False;
   end Extinctp;

end Numerics.SSA;
