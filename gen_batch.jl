#!/bin/bash
# -*- mode: julia -*-
#=
exec julia --project=. --color=yes --startup-file=no -e "include(popfirst!(ARGS))" "${BASH_SOURCE[0]}" "$@"
=#

include("common.jl")

function main(ARGS)
	if length(ARGS) != 5
		println(
			"Usage: ./$(basename(@__FILE__)) <seed> <L> <W> <qt_cuts> <qt_instances>"
		)
		println(
			"Note: For superset from which the instances in notable_instances" *
			" come from use: ./$(basename(@__FILE__)) 1 20 20 15 1000"
		)
		println(
			"The values of all parameters are in the name of every instance" *
			" (except the total number of instances generated, but this is" *
			" not relevant to obtaining it, only the number of the instance" *
			" is necessary)."
		)
		return
	end
	#format = Val(Symbol(ARGS[1]))
	seed = parse(Int, ARGS[1])
	L = parse(Int, ARGS[2])
	W = parse(Int, ARGS[3])
	qt_cuts = parse(Int, ARGS[4])
	qt_instances = parse(Int, ARGS[5])

	inst_folder = "./instances/"
	sol_folder = "./solutions/"
	for f in (inst_folder, sol_folder); mkpath(f); end

	rng = StableRNG(seed)
	for i in 1:qt_instances
		rects = gen_cut_rectangle(rng, L, W, qt_cuts)

		instance = gen_G2OPP_inst(Val(:SSSCSP), L, W, rects)
		qt_digits = ceil(Int, log10(qt_instances + 1))
		instance_number = lpad(i, qt_digits, '0')
		open(joinpath(inst_folder, "G2OPP_s$(seed)_L$(L)_W$(W)_n$(qt_cuts + 1)_i$(instance_number)"), "w") do io
			write_to_file(Val(:CPG_SSSCSP), instance, io)
		end

		open(joinpath(sol_folder, "G2OPP_s$(seed)_L$(L)_W$(W)_n$(qt_cuts + 1)_i$(instance_number).tikz"), "w") do io
			println(io, to_tikz(rects))
		end
	end

	return
end

main(ARGS)

