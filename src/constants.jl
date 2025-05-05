# cribbed from https://git.km3net.de/common/aanet/-/blob/master/evt/constants.hh

const _n = 1.3499
const _dndl = 0.0298
const _cos_cherenkov_angle = 1.0 / _n
const _speed_of_light = 299792458*1e-9

const constants = (
    n = _n,
    dndl = _dndl,
    speed_of_light = _speed_of_light,
    v_light = _speed_of_light/(_n + _dndl),
    v_group = _speed_of_light/(_n + _dndl),
    cos_cherenkov_angle = _cos_cherenkov_angle,
    θc = acos(_cos_cherenkov_angle)
)
