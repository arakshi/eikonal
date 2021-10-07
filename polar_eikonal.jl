"""
Правая часть системы ОДУ уравнения эйконала
в полярных координатах
    r <-> x[1],
  phi <-> x[2],
  p_r <-> x[3],
p_phi <-> x[4]
"""
function eikonal(t::Float64, x::Vector{Float64})::Vector{Float64}
  local nr::Float64
  local ∂nr::Float64
  local res::Vector{Float64} = zeros(4)

  nr = n(x[1])
  ∂nr = ∂n(x[1])
  res[1] = x[3]
  res[2] = x[4] / x[1]
  res[3] = nr * ∂nr + x[4]^2 / x[1]
  res[4] = -x[3]*x[4]/x[1]
  return res
end
