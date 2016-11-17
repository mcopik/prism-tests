dtmc


module first
	s : [0..3] init 0;
    	flag : bool init false;

	[] (s=0) -> 1.0 : (s'=1);
	[] (s=1) -> 0.7 : (s'=0) + 0.1 : (flag'=true) + 0.1 : (s'=2) + 0.1 : (s'=3);
	// First loop - transition reward will be zero
	[] (s=2) -> 1.0 : (s'=2);
	// Second loop - transition reward positive
	[] (s=3) -> 1.0 : (s'=3);
endmodule

rewards "reward"
	// Assign different value
	[] s < 2 : s;
	// Zero when entering first loop
	[] s >= 2 : s - 1;
	s < 2 : s + 1;
	s >= 2 : 2*s - 1;
endrewards
