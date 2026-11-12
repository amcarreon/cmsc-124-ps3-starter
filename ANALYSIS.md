# Environments and the Toy Evaluator
Using the P16 case, the trace on the eval-expr is this: 
```
(eval-expr	‘(let ((factor 2)) 
(let ((f (lambda (n) (* n factor)))) 
(let ((factor 10)) 
(f 3))))
‘()) 
```
The `eval-expr` has the head let, so it triggers the `(eval-let expr env)` call. The outer let bindings is `((factor 2))` the body is the second let. The names now contain `(factor)` and the inits contain `(2)`. The `(lambda (init) (eval-expr init env))` then applies it to each inits, evaluating each with the given env. The last let extends the env and adds the new names, vals, and env. The next bindings is `((f (lambda (n) (* n factor))))`, so the `names = (f)`, and `inits = ((lambda (n) (* n factor)))`. It will result to this lambda initializer `(eval-expr '(lambda (n) (* n factor)) '((factor . 2)))`. The eval-expr then recognizes a lambda expression and calls make-closure clause: `(make-closure '(n) '(* n factor) '((factor . 2)))`, capturing the current env `((factor . 2))`, with the closure result of `(:closure (n) (* n factor) ((factor . 2)))`. `f` is then binding with the closure. The last let binds `((factor 10))`, similar to the outer let, the bindings is `((factor 10)`. So the env now is `((factor . 10) (f . closure) (factor . 2))` with body `(f 3)`, lookup to f, the head, returns closure. The evaluated operand is 3, then calls apply-closure for the captured extended env with `((n . 3) (factor . 2))`, hence this expression `(* n factor)` results to 6.
