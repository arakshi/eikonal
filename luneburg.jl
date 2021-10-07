"""Коэффициент преломления для линзы Люниберга"""
function n(x::Float64, y::Float64)::Float64
    r = (x - X_0)^2 + (y - Y_0)^2 |> sqrt
    if r <= R
        return n_0*sqrt(2 - (r/R)^2)
    else
        return n_0
    end
end

"""Частные производные коэффициента преломления для линзы Люниберга"""
function ∂n(x::Float64, y::Float64)::Tuple{Float64, Float64}
    r = (x - X_0)^2 + (y - Y_0)^2  |> sqrt
    if r <= R
        return (-n_0^2 * (x - X_0) / (n(x, y)*R^2),
                -n_0^2 * (y - Y_0) / (n(x, y)*R^2))
    else
        return (0.0, 0.0)
    end
end

"""Коэффициент преломления для линзы Люниберга 
для полярных координат"""
function n(r::Float64)::Float64
    if r <= R
        return n_0*sqrt(2 - (r/R)^2)
    else
        return n_0
    end
end

"""Производная коэффициента преломления для
 линзы Люниберга для полярных координат"""
function ∂n(r::Float64)::Float64
    if r <= R
        return -n_0^2 * r / (n(r)*R^2)
    else
        return 0.0
    end
end
