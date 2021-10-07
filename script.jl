include("RK.jl") 
include("parameters.jl") 
include("luneburg.jl") 
include("src/eikonal.jl")

isdir(dir[lens]) ? true : mkdir(dir[lens]) 
file1 = open("./$(dir[lens])/data_x.txt", "a") 
file2 = open("./$(dir[lens])/data_y.txt", "a")

xn_0 = Vector{Float64}(undef, 4)

for (i, α) in enumerate(range(α_min, stop=α_max, length=50)) 
xn_0[1:2] = [x_0, y_0] 
xn_0[3:4] = [cos(α)*n(x_0, y_0), sin(α)*n(x_0, y_0)] 
tn, xn = RK.RKp6n1(eikonal, xn_0, h, t_start, t_stop) 
write(file1, "$(xn[:,1])\n") 
write(file2, "$(xn[:, 2])\n") 
end 
close(file1) 
close(file2)