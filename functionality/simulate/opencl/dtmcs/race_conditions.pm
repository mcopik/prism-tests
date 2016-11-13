dtmc

// Four states:
// Local: (0,1,0)
// Global: (2,0,0)
// Global&local: (0, 1, 2)
// Final: ( 0, 1, 1)

// Local -> Local OR Global
// Global -> Final OR Global&Local
// Global&Local -> Local or  global
// Final -> Final

label "global_local" = s1 = 0 & s2 = 1 & s3 = 2;

module first

	s1 : [0..5] init 0;
	s2 : [0..6] init 1;

	// Local race condition
	[] (s1 = 0) & (s2 = 1) & (s3 < 1) -> 0.5 : (s1'= s2 + 1) & (s2'=s1*3) +
		0.5 : (s1'= min(2*s2, s2 - 1)) & (s2'= 3*(s1+1) - 2);
	// Global race condition.
	[glob] (s1 = 2) & (s2 = 0) -> 1.0 : (s1'= s3) & (s2'= s3+1);
	// Global and local RC - go to local
	// Additional guards on second module variables are necessary -
	// otherwise PRISM wouldn't build the model
	[glob_loc1] (s1 = 0) & (s2 = 1) & (s3=2) -> 0.5 : (s2'= ceil(s3/2)) & (s1'= 2*s2 - s3)
		+ 0.5 : (s2'= ceil(pow(s2 + s3, 1)) - 3) & (s1'= s1 + s3);
	// Final
	[] (s1 = 0) & (s2 = 1) & (s3 = 1) -> true;
endmodule

module second
	s3 : [0..2] init 0;

	// Global race condition
	[glob] (s3= 0) & (s1=2) & (s2= 0) -> (s3'= ceil(s1/2)*2 - 1);
	[glob] (s3= 0) & (s1=2) & (s2= 0) -> (s3'= ceil(s1/2) + 1);
	// Global and local - go to local
	[glob_loc1] (s3 = 2) & (s1 = 0) & (s2 = 1) -> 1.0 : (s3'= s1);
	
endmodule