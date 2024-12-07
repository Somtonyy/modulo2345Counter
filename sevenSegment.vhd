library ieee;
use ieee.std_logic_1164.all;

ENTITY sevenSegment IS 
    PORT( 
	     A, B, C, D : IN std_logic;
        fa, fb, fc, fd, fe, ff, fg : OUT std_logic
		  );
END sevenSegment;

ARCHITECTURE logic_func OF sevenSegment IS
BEGIN
	fa <= (not(D) and not(C) and not(B) and A) or (not(D) and C and not(B) and not(A)) or (D and not(C) and B and A) or (D and C and not(B) and A);
	
	fb <= (not(D) and C and not(B) and A) or (not(D) and C and B and not(A)) or (D and not(C) and B and A) or (D and C and not(B) and not(A)) 
	                   or (D and C and B and not(A)) or (D and C and B and A);
							 
	fc <= (not(D) and not(C) and B and not(A)) or (D and C and not(B) and not(A)) or (D and C and B and not(A)) or (D and C and B and A);
	
	fd <= (not(D) and not(C) and not(B) and A) or (not(D) and C and not(B) and not(A)) or (not(D) and C and B and A) or (D and not(C) and B and not(A)) 
	             or (D and C and B and A);
					 
	fe <= (not(D) and not(C) and not(B) and A) or (not(D) and not(C) and B and A) or (not(D) and C and not(B) and not(A)) or (not(D) and C and not(B) and A) 
	            or (not(D) and C and B and A) or (D and not(C) and not(B) and A);	
					
	ff <= (not(D) and not(C) and not(B) and A) or (not(D) and not(C) and B and not(A)) or (not(D) and not(C) and B and A) or (D and C and not(B) and A);
	
	fg <= (not(D) and not(C) and not(B) and not(A)) or (not(D) and not(C) and not(B) and A) or (not(D) and C and B and A) or (D and C and not(B) and not(A));


END logic_func;
