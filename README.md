# GeneratorG2OPP

Julia 1.5.4 was used to run these scripts.

Gurobi is only needed for the script inside 'gurobi\_simplex\_vs\_barrier' that shows that Gurobi 9.1.2 solves correctly a model with the default parameters and incorrectly if the LP-solving method is changed to barrier. If you only want to generate instances, you can ignore the Gurobi dependency.

If you wanna do the test, but does not have Julia configured, you can also use the pre-generated MPS inside the same folder.

The following command gives an unfeasible model in Gurobi 9.1.2.

```
gurobi_cl Method=2 Seed=1 Threads=1 G2OPP_s1_L20_W20_n16_i0135.mps
```

However, if you take out any of the parameters (either `Method`, `Seed`, or `Threads`) then Gurobi finds a feasible solution.


