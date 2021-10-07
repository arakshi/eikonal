module RK
"""
Метод Рунге--Кутты с постоянным шагом интегрирования. Результаты вычислений и
моменты времени записываются в массивы и возвращаются функцией. Для вычислений
на большом отрезке времени следует использовать версию, где возвращается
лишь последнее вычисленное значение.
```
RKp6n1(func, x_0, h, start, stop) -> (t, x)
RKp6n1(func, x_0, h, start, stop, last) -> (T, X)
```

# Arguments

* `func::Function`: right side of ODE.
* `x_0::Vector{Float64}`: initial value of `x(t)`.
* `h::Float64`: method step size.
* `start::Float64`: time interval first point.
* `stop::Float64`: time interval last point.
* `last::Bool`: indicates, that function shell return only last value

# Return values

* `t::Float64`: time value
* `x::Vector{Float64}`: approximation of `x(stop)`

* `T::Array{Float64, 1}`: times values `[start, stop]`.
* `X::Array{Float64, EQN}`: numerical solution in the form of array with 
  `EQN` columns and `N` rows.
"""
function RKp6n1(func::Function, x_0::Vector{Float64}, h::Float64, start::Float64, stop::Float64, last::Bool)::Tuple{Float64,Vector{Float64}}

  t = start
  x = copy(x_0)
  EQN = length(x_0)

  k1 = zeros(Float64, EQN)
  k2 = zeros(Float64, EQN)
  k3 = zeros(Float64, EQN)
  k4 = zeros(Float64, EQN)
  k5 = zeros(Float64, EQN)
  k6 = zeros(Float64, EQN)
  k7 = zeros(Float64, EQN)

  while t <= stop
    k1 = func(t, x)
    k2 = func(t + 1//2*h, x + h*(1//2*k1))
    k3 = func(t + 2//3*h, x + h*(2//9*k1 + 4//9*k2))
    k4 = func(t + 1//3*h, x + h*(7//36*k1 + 2//9*k2 + -1//12*k3))
    k5 = func(t + 5//6*h, x + h*(-35//144*k1 + -55//36*k2 + 35//48*k3 + 15//8*k4))
    k6 = func(t + 1//6*h, x + h*(-1//360*k1 + -11//36*k2 + -1//8*k3 + 1//2*k4 + 1//10*k5))
    k7 = func(t + 1//1*h, x + h*(-41//260*k1 + 22//13*k2 + 43//156*k3 + -118//39*k4 + 32//195*k5 + 80//39*k6))

    x = x + h*(13//200*k1 + 11//40*k3 + 11//40*k4 + 4//25*k5 + 4//25*k6 + 13//200*k7)
    t = t + h
  end
  return (t, x)
end # RKp6n1


function RKp6n1(func::Function, x_0::Vector{Float64}, h::Float64, start::Float64, stop::Float64)
  EQN = length(x_0)
  # Массив, содержащий точки временной сетки
  # хочется сразу создать массив X нужной длины
  T = Array{Float64, 1}()
  for t in Iterators.countfrom(start, h) # бесконечная итерация от t1 с шагом h
    push!(T, t)
    t <= stop ? continue : break # условия прерывания цикла
  end

  N = length(T)
  # В массиве X N строк и EQN столбцов
  X = Array{Float64, 2}(undef, N, EQN)
  k1 = zeros(Float64, EQN)
  k2 = zeros(Float64, EQN)
  k3 = zeros(Float64, EQN)
  k4 = zeros(Float64, EQN)
  k5 = zeros(Float64, EQN)
  k6 = zeros(Float64, EQN)
  k7 = zeros(Float64, EQN)
  # Портится x_0 если не делать copy
  x = copy(x_0)

  for (i, t) in enumerate(T)
    X[i,:] = x

    k1 = func(t, x)
    k2 = func(t + 1//2*h, x + h*(1//2*k1))
    k3 = func(t + 2//3*h, x + h*(2//9*k1 + 4//9*k2))
    k4 = func(t + 1//3*h, x + h*(7//36*k1 + 2//9*k2 + -1//12*k3))
    k5 = func(t + 5//6*h, x + h*(-35//144*k1 + -55//36*k2 + 35//48*k3 + 15//8*k4))
    k6 = func(t + 1//6*h, x + h*(-1//360*k1 + -11//36*k2 + -1//8*k3 + 1//2*k4 + 1//10*k5))
    k7 = func(t + 1//1*h, x + h*(-41//260*k1 + 22//13*k2 + 43//156*k3 + -118//39*k4 + 32//195*k5 + 80//39*k6))

    x = x + h*(13//200*k1 + 11//40*k3 + 11//40*k4 + 4//25*k5 + 4//25*k6 + 13//200*k7)

  end
  return T, X
end # RKp6n1

end #module RK
