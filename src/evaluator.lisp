;;;; evaluator.lisp -- Part 2. Write the eight functions below.
;;;;
;;;; The toy language is a Lisp-1. One namespace holds both variables and
;;;; functions, so a variable bound to a closure is callable in operator
;;;; position and (f 1) works with no FUNCALL. The CLISP hosting this file is a
;;;; Lisp-2, which is why the host needs FUNCALL and #' where the toy language
;;;; needs neither. ANALYSIS.md asks you about that difference.
;;;;
;;;; An environment is an association list: ((name . value) (name . value) ...).
;;;; The grader scores E1 to E4 separately, so finish them in order and keep
;;;; every group you get right.
;;;;
;;;; The grammar, in full:
;;;;
;;;;   expr := number
;;;;         | symbol
;;;;         | (+ expr expr) | (- expr expr) | (* expr expr)
;;;;         | (let ((name expr) ...) body)
;;;;         | (lambda (name ...) body)
;;;;         | (operator-expr argument-expr ...)

;;; E1 -- numbers and symbols.

(defun lookup (name env)
  "The value NAME is bound to in ENV.

The first match wins, so an inner binding shadows an outer one that shares its
name. Signal an error when NAME is not bound at all."
  (cond
    ;; base case, unbound symbol flags an error
    ((null env)
      (error "unbound error: ~a" name))

    ;; finds first pair with matching name
    ;; car env is first pair -> (car (car env)) is the name of that pair
    ((eq name (car (car env)))
      ;; (cdr (car env)) is the value of the pair
      (cdr (car env)))

    ;; no match so it looks at the rest of the items by recursion
    (t (lookup name (cdr env)))
  )
)

;;; E2 -- prefix arithmetic.

(defun eval-operands (exprs env)
  "Every expression in EXPRS, evaluated in the same ENV, as a list.

MAPCAR and a LAMBDA do this in one line. Watch the arity: EVAL-EXPR takes two
arguments and MAPCAR hands its function one."
    ;; evaluates each expression in the list using eval-expr
    ;; lambda receives one expression at a time from mapcar
    (mapcar (lambda (expr)
        (eval-expr expr env))
        exprs)
)

(defun apply-op (op values)
  "Apply the arithmetic operator OP to the two numbers in VALUES.

OP is the symbol +, -, or *. Signal an error for anything else."

    ;; checks if the operator is +, -, or *
    (unless (member op '(+ - *) :test #'eq)
        (error "Unknown arithmetic operator: ~a" op))

    ;; checks if there are exactly two operands
    (unless (= (length values) 2)
        (error "Arithmetic requires exactly two operands"))

    ;; checks if all operands are numbers
    (unless (every #'numberp values)
        (error "Arithmetic operands must be numbers"))
        
    ;; performs the operation based on the given operator
    (case op
        (+ (+ (first values) (second values)))
        (- (- (first values) (second values)))
        (* (* (first values) (second values))))
)


;;; E3 -- let.

(defun extend-env (params args env)
  "ENV with PARAMS bound to ARGS in front of it.

MAPCAR takes two lists and #'CONS pairs them. Build a new list. Do not modify
ENV, because the caller keeps using it after the extension goes out of scope."
  ;; pairs the list of params and args
  ;; append returns a new list of new pairs in front, env unchanged
  (append (mapcar #'cons params args) env)
)

(defun eval-let (expr env)
  "Evaluate (let ((name init) ...) body).


Every init is evaluated in ENV before any name is bound, so the bindings happen
in parallel and an init cannot see a name the same LET introduces."
  ;; splits the form, evaluates every initializer in the env
  ;; extends it with new pairs, and evaluates that body
  (let ((bindings (second expr))
      (body (third expr)))
    (let ((names (mapcar #'first bindings))
        (inits (mapcar #'second bindings)))
      (let ((vals (mapcar (lambda (init) (eval-expr init env)) inits)))
        (eval-expr body (extend-env names vals env))
      )
    )
  )
)

;;; E4 -- lambda and application.

(defun make-closure (params body env)
  "A closure over ENV.

Return the list (:closure params body env). ENV is the environment the lambda
was written in, not the one it will later be called from. Saving the wrong one
is what makes the difference between 3 and 101 in the case the manual walks
through."
    ;; saves the parameters, function body, and defining environment
    (list :closure params body env))

(defun apply-closure (closure args)
  "Run CLOSURE on ARGS.

The parameters join the environment the closure captured. Signal an error when
CLOSURE is not a closure, and when the argument count does not match."
    ;; checks if the given value is a valid closure
    (unless (and (consp closure)
        (eq (first closure) :closure)
        (= (length closure) 4))
    (error "Invalid closure"))

    ;; gets the parameters, body, and saved environment
    (let ((params (second closure))
        (body (third closure))
        (env (fourth closure)))

    ;; checks if the number of arguments matches the parameters
    (unless (= (length params) (length args))
        (error "Incorrect number of arguments"))

    ;; extends the saved environment with the arguments
    ;; then evaluates the function body in that environment
    (eval-expr body (extend-env params args env)))
)

;;; The dispatcher.

(defun eval-expr (expr env)
  "The value of EXPR in ENV.

Order the branches with care. NIL is a symbol as well as the empty list, and a
number is not a cons, so the atom tests come before the list tests."
  (cond
    ;; number evaluates to itself
    ((numberp expr)
      expr)

    ;; symbol goes through lookup
    ((symbolp expr)
      (lookup expr env))

    ;; arithmetic expressions
    ((and (consp expr)
          (member (car expr) '(+ - *)))
        (apply-op
          (car expr)
          (eval-operands (cdr expr) env)))
    
    ;; let expressions
    ((and (consp expr) 
      (eq (car expr) 'let))
      (eval-let expr env))

    ;; recognizes lambda expressions and creates a closure
    ((and (consp expr)
        (eq (car expr) 'lambda))
    (make-closure
        (second expr)
        (third expr)
        env))

    ;; evaluates the function and its arguments, then applies the closure
    ((consp expr)
        (apply-closure
            (eval-expr (car expr) env)
            (eval-operands (cdr expr) env)))
  )
)
