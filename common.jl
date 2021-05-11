using GuillotineModels.Data: write_to_file, SSSCSP
using StableRNGs: StableRNG

# We did not care for perfomance in the code below.
# We are interested in printing solutions to tikz after, so what we did
# was to keep the 4 coordinates along the process and only discard them
# when the instance is really created.
function gen_cut_rectangle(
	rng, L :: S, W :: S, qt_cuts :: D
) where {S, D}
	debug = false
	#plates_dict = Dict{Tuple{S, S} => D}((L, W) => D)
	plates_vec = Tuple{S, S, S, S}[(0, 0, L, W)] # x, y, L, W
	local done
	for i in 1:qt_cuts
		done = false
		num_tries = 0
		debug && println("cut n: $i")
		while !done && num_tries < 10
			cut_L = rand(rng, Bool)
			debug && @show cut_L
			chosen_plate = rand(rng, 1:length(plates_vec))
			x, y, cL, cW = plates_vec[chosen_plate]
			debug && @show x, y, cL, cW
			if cut_L
				if cL - x < 2
					num_tries += 1
					debug && println("too small, aborting")
					continue
				end
				chosen_fcl = rand(rng, 1:((cL - x) - 1))
				push!(plates_vec, (cL - chosen_fcl, y, cL, cW))
				plates_vec[chosen_plate] = (x, y, cL - chosen_fcl, cW)
				debug && @show last(plates_vec)
				debug && @show plates_vec[chosen_plate]
			else
				if cW - y < 2
					num_tries += 1
					debug && println("too small, aborting")
					continue
				end
				chosen_fcw = rand(rng, 1:((cW - y) - 1))
				push!(plates_vec, (x, cW - chosen_fcw, cL, cW))
				plates_vec[chosen_plate] = (x, y, cL, cW - chosen_fcw)
				debug && @show last(plates_vec)
				debug && @show plates_vec[chosen_plate]
			end
			done = true
		end
	end
	#println(stderr, plates_vec)

	!done && error("failed to cut many times, too much cut for too little plate")

	return plates_vec
end

function to_tikz(
	rects :: Vector{Tuple{S, S, S, S}}
) where {S}
	body = join(map(enumerate(rects)) do (i, (x, y, cL, cW))
		cl, cw = x + (cL - x)/2, y + (cW - y)/2
		"\\draw[dashed, thick, black] ($x, $y) rectangle ($cL, $cW);" *
		"\\node[font=\\LARGE] at ($cl, $cw) {$i};"
	end, '\n')
	return "\\begin{tikzpicture}\n$body\n\\end{tikzpicture}"
end

function gen_G2OPP_inst(
	::Val{:SSSCSP}, L, W, rects :: Vector{Tuple{S, S, S, S}}
) where {S}
	lw = map(rects) do (x, y, cL, cW)
		(cL - x, cW - y)
	end

	lwd = map(lw) do (li, wi)
		(li, wi, sum(map(((lii, wii),) -> li == lii && wi == wii, lw)))
	end

	lwd = unique(lwd)
	l, w, d = Vector{S}(), Vector{S}(), Vector{S}()
	for lwdi in lwd
		push!.((l, w, d), lwdi)
	end

	return SSSCSP{S, S, S}(L, W, l, w, d)
end
