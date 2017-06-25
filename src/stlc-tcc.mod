module stlc-tcc.

prog (tcc (toInt _) intTy) (tt).
prog (tcc nl listTy) (tt).
prog (tcc hd (funTy listTy intTy)) (tt).
prog (tcc tl (funTy listTy listTy)) (tt).
prog (tcc cns (funTy intTy (funTy listTy listTy))) (tt).
