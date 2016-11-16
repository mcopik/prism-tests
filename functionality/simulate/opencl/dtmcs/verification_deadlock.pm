dtmc


module first
	s : [0..2] init 0;
    flag : bool init false;

	[] (s=0) -> 1.0 : (s'=1);
	[] (s=1) -> 0.8 : (s'=0) + 0.1 : (flag'=true) + 0.1 : (s'=2);
	// Deadlock
endmodule

rewards "reward"
	// Assign different value
	[] true : s;
	s < 2 : s + 1;
	s >= 2 : 2*s - 1;
endrewards
