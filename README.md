# SATCaml
SATCaml is a SAT Solver written in OCaml. It takes in a formula in CNF (conjunctive normal form) and decides if the formula is satisfiable. If it is, it will give a truth assignment that makes such formula true.
> In computer science, the **Boolean Satisfiability Problem** (sometimes called **Propositional Satisfiability Problem** and abbreviated as **SATISFIABILITY** or **SAT**) is the problem of determining if there exists an interpretation that satisfies a given Boolean formula. In other words, it asks whether the variables of a given Boolean formula can be consistently replaced by the values TRUE or FALSE in such a way that the formula evaluates to TRUE. If this is the case, the formula is called satisfiable. On the other hand, if no such assignment exists, the function expressed by the formula is FALSE for all possible variable assignments and the formula is unsatisfiable. For example, the formula "a AND NOT b" is satisfiable because one can find the values a = TRUE and b = FALSE, which make (a AND NOT b) = TRUE. In contrast, "a AND NOT a" is unsatisfiable.

## How to run
This guide assumes you will be using `ocaml` toplevel. It should be similar for other ones such as `utop`.

`.ocamlinit` already takes care of including `Str.cma` and `SAT.ml`, but if you are not using `.ocamlinit`, run the following commands
```
#load "str.cma";;
#use "SAT.ml";;
```
Then use `SAT ();;` to start the program. You should be asked to input the clauses of the CNF form of the formula.
```
add a clause:
```
Let's say the formula F is `(NOT A) and (B or C) or (NOT C)`, use `~T` to represent `NOT T` and separate terms in each clause by a space.
```
add a clause: ~A
add a clause: B C
add a clause: ~C
```
When you are done, simply enter an empty clause by pressing enter key.

Then SATCaml should tell you the result, and here is the example output for F:
```
(true, [("A", false); ("B", true); ("C", false)])
```
which means this formula is satisfiable, and a sample truth assignment is A = 0, B = 1, and C = 0.
