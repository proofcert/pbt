sig fpcs.
accum_sig kernel.
accum_sig random.


/* resources */
type   height   int -> cert.
type   sze     int -> int -> cert.
/* end */

/* random */
type   random   cert.
/* end */
type   rtries    int -> cert.
type   rtriesW   string -> int -> cert.

type   iterate   int -> o.

/* max */
kind max     type.
type max     max    -> cert.
type binary  max    -> max -> max.
type choose  choice -> max -> max.
type term    A      -> max -> max.
type empty   max.
/* end */

/* pairing */
type   <c>     cert ->  cert ->  cert.
infixr <c>     5.
/* end */

type l-or-r    list choice -> 
               list choice -> cert.

kind nat     type.
type zero    nat.
type succ    nat -> nat.

/* collect */
kind item                     type.
type c_nat             nat -> item.
type c_list_nat   list nat -> item.

type subterm      item -> item -> o.
type collect      list item -> list item -> cert.
/* end */
% type c1      list item -> cert.
/* huniv */
type huniv   (item -> o) -> cert.
/* end */
type tries int -> o.

/* weights */
kind qform       type.
%type qtt, qeq    qform.
type qid         qform.
type qand        qform -> qform -> qform.
type qor         int -> int -> qform -> qform -> qform.
%type qsome       qform -> qform.
type qprog       string -> qform.

type qdistr    string -> qform -> o.
type qchoose   int -> int -> choice -> o.

type qw   qform -> cert.
/* end */

% Another approach to weighing clause

/* weight_cert */
type noweight      cert.
type cases         int -> list int -> int -> cert.
/* end */

/* weight_pred */
type weights       sl -> list int -> o.
/* end */
