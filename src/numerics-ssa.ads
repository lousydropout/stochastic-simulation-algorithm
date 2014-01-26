with Numerics.Real_Arrays; use Numerics.Real_Arrays;
with Ada.Text_IO; use Ada.Text_IO;
generic

   type Rxn_Range is range <>;
   type Species_Range is range <>;
   
   with function Reaction (I : in Rxn_Range;
			   C : in Real_Vector;
			   Y : in Natural_Vector) return Real;
   with function ΔY (I : in Rxn_Range) return Int_Vector;
   
package Numerics.SSA is
   
   procedure Print_CSV (File : in File_Type;
			Item : in Natural_Vector);
   
   procedure Print_CSV (File : in File_Type;
			τ    : in Real;
			Item : in Natural_Vector) with Inline => True;
   
   procedure Print_CSV (τ    : in Real;
			Item : in Natural_Vector) with Inline => True;
   
   procedure Print_Header (File : in File_Type;
			   Item : in Natural_Vector);
   
   procedure Print_Header (τ    : in Real;
			   Item : in Natural_Vector) with Inline => True;
     
   procedure Calc_TM (Y	: in     Natural_Vector;
		      C	: in     Real_Vector;
		      τ	:    out Real;
		      μ	:    out Rxn_Range);
   
   procedure Update (Y	  : in out Natural_Vector;
		     C	  : in     Real_Vector;
		     Time : in out Real);
   
   function Extinctp (Y	: in Natural_Vector) return Boolean;
   
   
   EXTINCTION : exception;
end Numerics.SSA;
