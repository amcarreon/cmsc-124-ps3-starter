# Reasoning for the Predictions Table

## P01
This case evaluates a function, the head  `+`, evaluating the arguments as usual, and the quote hands the unevaluated form of `(+ 1 (* 2 3))`. Starting at the inner expression `(* 2 3)`, resulting in `6`, then outer expression: `(+ 1  6)`. Hence, the evaluated value is `7`, which is an integer that takes `none` for the length, as it only applies to sequences like list.

## P02
The extra quotation mark `''` preserves the expression and no evaluation is done. The result is the list `(+,1,2)` with 3 elements, with kind as `cons`, length `3` and operator as `special-operator` because the quotation uses the special operator quote.

## P03
`nil` is a symbol, not a call, it has no head, so the operator is `none`. The quote hands it over unevaluated. When it evaluates itself, the value is `nil`. Its kind is `null`, and since `nil` is an empty list, the length is `0`.

## P04
`t` represents true. The quotation mark prevents evaluation and simply returns the symbol itself. Its kind is `symbol`, with no length, and `none` in operator since no function is called.

## P05
The head is `symbolp`, a function, which is also the operator. It evaluates the `nil` to itself, whether it is a symbol, and since `nil` is a symbol, the value results to true, `t`, which is also `symbol` with length `none`. 

## P06
`car` retrieves the first element of a list but since the list is empty: `()`, the first element doesn't exist. This results in a `nil` or empty list as the value, `null` as its kind, `0` length, and is a `function`.

## P07
`cons` is the head of the `'(cons 1 '(2 3))`, which is a function that holds two references, the `1` and `'(2 3)`, returned unevaluated, in here. It returns a list of chain of cons cells, hence, the value is a three-item list, `(1,2,3)`. `cons` is its kind.

## P08
`null` checks if a value is `nil` and since the empty list `()` is also considered as `nil`, it satisfies the condition, resulting in true or `t`. It then chooses `empty` since it is `t`. `empty` is a `symbol` with no length and is a special-operator because `if` controls which expression gets evaluated.

## P09
`and` is the head of this case, both a special-operator and a macro. It evaluates arguments from left to right and stops when encounters a false, and `nil` is false. Even though `1` is true, it takes the `nil` and returns without evaluating `3`. Hence, its value is `nil`, and the kind is `null`, still the length `0` as empty list, but this case takes the operator of `special-operator` since it first checks as a special operator.

## P10
`defvar` declares `ps3-rate` as a variable with a set value 2. The `let` temporarily changes its value to 10, and `ps3-scale` uses that active value when multiplying 3 by 10, resulting in 30. Its kind is integer since `30` is a whole number with no length and it is a special-operator since `progn` executes multiple expressions and returns the last result.

## P11
The head is `defun`, which is a macro, and defines a function with function symbol as its value, `ps3-twice`, so the kind is `symbol`. The length in here is `none` since symbol is not a sequence.

## P12
`labels` defines a local recursive function named down. The function repeatedly subtracts 1 and uses cons to build a list until it reaches 0. It produces `(3,2,1)` whose kind is `cons` because it is a list of length `3` and is `special-operator` because `labels` is a special operator to define local functions.

## P13
The head is a `mapcar` that applies a function, its operator, to every item in the handed list and returns the result list. `#'length` is applied to the nested unevaluated list `'((1 2) () (3))`, which gives the length of each as the value, `(2,0,1)`, and the actual length of the result list is `3`. The list is a chain of cons cells, so the kind is `cons`.

## P14
`mapcar` applies the lambda function to every element in the list. Since the lambda multiplies each number by itself, the results are 1, 4, and 9, producing `(1,4,9)`. The kind is `cons` since it is a list of length `3`. Since `mapcar` is a function, then it is the operator.

## P15
`lambda` is the head and it is a macro that defines a function without a name. In here, `'(lambda (n) (* n 2))` defines a function with parameter `n` and applies `(* n 2)` to it that multiplies n by 2. It returns the function object, which is `#<function>`, as its value, and the kind is a `function` with the length of `none` since it is not a list.

## P16
The `lambda` function captures the value of `factor` from its original lexical environment, where it has value 2. Even though another `factor` is later declared with the value 10, the function still uses the original value, so 3 × 2 = 6. Its kind is integer since `6` is a whole number and has no length since it is not a list and is a `special-operator` because `let` establishes local variable bindings.
