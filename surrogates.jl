# импорт библиотеки 
using Surrogates
using Plots
default()

# инициация начальных значений 
f(x) = sin(x) 
n_samples = 15 
lower_bound = 0.0 
upper_bound = 30.0

# метод сетки 
x_grid = sample(n_samples, lower_bound, upper_bound, GridSample(0.2)) 
y_grid = f.(x_grid)

# метод случайных значений 
x_uniform = sample(n_samples, lower_bound, upper_bound, UniformSample()) 
y_uniform = f.(x_uniform)

# метод соболя 
x_sobol = sample(n_samples, lower_bound, upper_bound, SobolSample()) 
y_sobol = f.(x_sobol)

# метод латиского гиперкуба 
x_lh = sample(n_samples, lower_bound, upper_bound, LatinHypercubeSample()) 
y_lh = f.(x_lh)

# визуализация результата выборки 
plot(f, label="True function", xlims=(lower_bound-1, upper_bound+1), title = "Samples methods") 
scatter!(x_grid, y_grid, label="Grid method") 
scatter!(x_uniform, y_uniform, label="Uniform method") 
scatter!(x_sobol, y_sobol, label="Sobol method") 
scatter!(x_lh, y_lh, label="Latin Hypercube method", legend=:outerbottomright) 
xlabel!("x") 
ylabel!("f(x)") 
plot!(size=(900,400))

# радиально-базисный метод 
RBF_surrogate = RadialBasis(x, y, lower_bound, upper_bound)

# кригинг 
kriging_surrogate = Kriging(x, y, lower_bound, upper_bound, p=1.9)

# метод лобачевского 
lobachevsky_surrogate = LobacheskySurrogate(x, y, lower_bound, upper_bound, alpha = 2.0, n = 6)

# метод обратных взвешенных расстояний 
InverseDistance = InverseDistanceSurrogate(x, y, lower_bound, upper_bound)

# визуализация результата моделтрования
plot(x, y, seriestype=:scatter, label="Sampled points", xlims=(lower_bound, upper_bound), title = "Surrogates methods") 
plot!(f, label="True function", xlims=(lower_bound, upper_bound), w=1.5) 
plot!(RBF_surrogate, label="Radial Surrogate function", xlims=(lower_bound, upper_bound)) 
plot!(kriging_surrogate, label="Kriging Surrogate function", xlims=(lower_bound, upper_bound), legend=:outerbottomright) 
#plot!(lobachevsky_surrogate, label="Lobachevsky Surrogate function", xlims=(lower_bound, upper_bound), legend=:outerbottomright) 
plot!(InverseDistance, label="Inverse Distance Surrogate function", xlims=(lower_bound, upper_bound), legend=:outerbottomright) 
xlabel!("x") 
ylabel!("f(x)") 
plot!(size=(900,400))