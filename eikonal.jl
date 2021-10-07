"""
Правая часть системы ОДУ уравнения эйконала
  x <-> x[1],
  y <-> x[2],
p_1 <-> x[3],
p_2 <-> x[4]
"""
function eikonal(t::Float64, x::Vector{Float64})::Vector{Float64}
  """Уравнения Гамильтона, записанные для уравнения эйконала"""
  local nn::Float64
  local ∂nx::Float64
  local ∂ny::Float64
  local res::Vector{Float64} = zeros(4)
  nn = n(x[1], x[2])
  ∂nx, ∂ny = ∂n(x[1], x[2])
  res[1] = x[3]/nn^2
  res[2] = x[4]/nn^2
  res[3] = ∂nx/nn
  res[4] = ∂ny/nn
  return res
end
