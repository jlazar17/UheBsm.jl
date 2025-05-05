struct Track
    dir::Vector{Float64}
    pos::Vector{Float64}
    t::Float64
    function Track(dir, pos, t)
        @assert length(dir)==3
        @assert length(pos)==3
        dir /= norm(dir)
        return new(dir, pos, t)
    end
end

(track::Track)(t) = constants.speed_of_light * (t - track.t) * track.dir + track.pos

struct Cascade
    pos::Vector{Float64}
    t::Float64
    function Cascade(pos, t)
        @assert length(pos)==3
        return new(pos, t)
    end
end
