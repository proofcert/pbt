sig random.

% Use this predicate to provide a scope when an oracle file is open and available.
type open_oracle        (string -> o) -> o -> o.
type open_oracle_file    string -> o -> o.

% Within the scope provided above, next_bit reads the bits one after another.
type next_bit  	    int -> o.

% A few tests 
type test           int -> list int -> o.

% Oracles as string instead of files.
type oracle1, oracle2, oracle3, oracle4, oracle5, oracle6, oracle7, oracle8   string -> o.

% Using the oracle, read in an 8 bit number.
type read_7_bits   int -> o.
