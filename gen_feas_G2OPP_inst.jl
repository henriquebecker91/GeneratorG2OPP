#!/bin/bash
# -*- mode: julia -*-
#=
exec julia --project=. --compile=min --color=yes --startup-file=no -e "include(popfirst!(ARGS))" "${BASH_SOURCE[0]}" "$@"
=#

include("common.jl")

function main(ARGS)
	if length(ARGS) != 4
		println("Usage: ./$(basename(@__FILE__)) <seed> <L> <W> <qt_cuts>")
		println(
			"Note: the instance will be printed to the standard output," *
			" but the solution to the standard error output."
		)
		return
	end
	#format = Val(Symbol(ARGS[1]))
	seed = parse(Int, ARGS[1])
	L = parse(Int, ARGS[2])
	W = parse(Int, ARGS[3])
	qt_cuts = parse(Int, ARGS[4])

	rng = StableRNG(seed)
	rects = gen_cut_rectangle(rng, L, W, qt_cuts)

	instance = gen_G2OPP_inst(Val(:SSSCSP), L, W, rects)
	iob = IOBuffer()
	write_to_file(Val(:CPG_SSSCSP), instance, iob)
	println(read(seekstart(iob), String))

	println(stderr, to_tikz(rects))

	return
end

main(ARGS)

