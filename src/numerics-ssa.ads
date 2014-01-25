with Numerics.Real_Arrays; use Numerics.Real_Arrays;

generic

   type Rxn_Range is range <>;
   type Species_Range is range <>;
   
   with function Reaction (I : in Rxn_Range;
			   C : in Real_Vector;
			   Y : in Natural_Vector) return Real;
   with function ΔY (I : in Rxn_Range) return Int_Vector;
   
package Numerics.SSA is
   
   procedure Print_CSV (τ    : in Real;
			Item : in Natural_Vector) with Inline => True;
   
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

end Numerics.SSA;
