mutable struct Hit
    pos::Vector{Float64}
    t::Float64
    tot::Float64
    #emission_pos::Dict{Track, Vector{Float64}}
    #emission_t::Dict{Track, Float64}
    #residual_t::Dict{Track, Float64}
    function Hit(pos, t, tot)
        @assert length(pos)==3
        return new(pos, t, tot)
    end
end

function Hit(d::Dict{String, Any})
    pos = [d[k] for k in ["pos_x", "pos_y", "pos_z"]]
    return Hit(pos, d["t"], d["tot"])
end

#function Hit(pos, t, tot)
#    return Hit(
#        pos,
#        t,
#        tot,
#        Dict{Track, Vector{Float64}}(),
#        Dict{Track, Float64}(),
#        Dict{Track, Float64}(),
#    )
#end

function sort_to_strings(hits::Vector{Hit}, thresh=20)
    split_hits = Vector{Hit}[]
    while length(hits) > 0
        hit = first(hits)
        xy_dist = map(x->sqrt(sum((hit.pos[1:2] .- x.pos[1:2]).^2)), hits)
        sorter = sortperm(xy_dist)
        xy_dist, hits = xy_dist[sorter], hits[sorter]
        idx = findlast(xy_dist .< thresh)
        push!(split_hits, hits[1:idx])
        hits = [x[1] for x in zip(hits, xy_dist) if x[2] > thresh]
    end
    return split_hits
end

function sort_to_doms(hits::Vector{Hit}, thresh=1)
    split_hits = Vector{Hit}[]
    while length(hits) > 0
        hit = first(hits)
        z_dist = map(x->abs(hit.pos[3] .- x.pos[3]), hits)
        sorter = sortperm(z_dist)
        z_dist, hits = z_dist[sorter], hits[sorter]

        idx = findlast(z_dist .< thresh)
        push!(split_hits, hits[1:idx])
        hits = [x[1] for x in zip(hits, z_dist) if x[2] > thresh]
    end
    return split_hits
end

 function sort_to_pmts(hits::Vector{Hit})
     sorted_hits = Vector{Hit}[]
     sort!(hits, by=x->x.pos[1])
     b = vcat(0, findall(x->~isapprox(x[1], 0), diff(map(x->x.pos[1], hits))))
     push!(b, length(hits))
     for (pmt_id, (idx, jdx)) in enumerate(zip(b, b[2:end]))
         push!(sorted_hits, hits[idx+1:jdx])
     end
     @assert sum(length.(sorted_hits))==length(hits)

     return sorted_hits
 end
