function cascade_distance(hit::Hit, track::Track; root=+)
    Δt = hit.t - track.t
    ℓ = hit.pos - track.pos
    β = constants.v_group / constants.speed_of_light
    y = constants.v_group * Δt
    a = 1 - β^2
    b = 2 * (y * β - dot(ℓ, track.dir))
    c = norm(ℓ) ^ 2 - y ^ 2
    d = sqrt(b^2 - 4 * a * c)
    return root(-b, d) / (2a)
end

function track_distance(hit::Hit, track::Track)
    h = hit.pos .- track.pos
    a = dot(h, track.dir)
    b = sqrt(maximum([norm(h)^2 - a^2, 0]))
    x = b / tan(constants.θc)
    h′ = x / cos(constants.θc)
    z = a - x
    return z
end

function residual(hit::Hit, track::Track)
    z = track_distance(hit, track)

    pos_emission = z * track.dir .+ track.pos
    h = norm(pos_emission - hit.pos)

    t_emission = track.t + z / constants.speed_of_light
    t_exp = t_emission + h / constants.v_group
    return hit.t - t_exp
end

function track_t(hit::Hit, track::Track)
    z = track_distance(hit, track)
    dt = z / constants.speed_of_light
    t = track.t + dt
    return t
end
