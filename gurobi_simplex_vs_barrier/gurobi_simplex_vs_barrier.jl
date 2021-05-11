#!/bin/bash
# -*- mode: julia -*-
#=
exec julia --project=. --compile=min --color=yes --startup-file=no -e "include(popfirst!(ARGS))" "${BASH_SOURCE[0]}" "$@"
=#

using GuillotineModels.CommandLine: run
import Gurobi

instance_folder = "../notable_instances/"
instance_name = "G2OPP_s1_L20_W20_n16_i0135"
instance_path = joinpath(instance_folder, instance_name)
parameters = [
	"G2OPP", "CPG_SSSCSP", "PPG2KP", "Gurobi", instance_path,
	"--PPG2KP-verbose", "--PPG2KP-round2disc"
]

print("\n\n\n\n\nRUN FOR SAVING MODEL\n\n\n\n\n")
# Run that gives feasible with Gurobi 9.1.2
run(vcat(
	parameters, [
		"--do-not-solve", "--save-model", instance_name * ".mps",
		"--use-native-save-model-if-possible"
	]
))

print("\n\n\n\n\nRUN THAT GIVES FEASIBLE SOLUTION\n\n\n\n\n")
# Run that gives feasible with Gurobi 9.1.2
run(parameters)

print("\n\n\n\n\nRUN THAT GIVES UNFEASIBLE SOLUTION\n\n\n\n\n")
# Run that gives unfeasible with Gurobi 9.1.2
run(vcat(parameters, ["--Gurobi-LP-method", "2"]))

