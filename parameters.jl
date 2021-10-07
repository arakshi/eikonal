# Общие для всех параметры

const dir = Dict(
  "maxwell"=>"Maxwell_data",
  "luneburg"=>"Luneburg_data")

"""Радиус линзы"""
const R = 1.0

"""Коэффициент преломления среды"""
const n_0 = 1.0

"""Координаты центра линзы"""
const X_0 = 2.0
const Y_0 = 0.0

# Границы области для декартовых координат
const x_min =  0.0
const x_max =  5.0
const y_min = -0.95
const y_max =  0.95

# Границы области для полярных координат
const phi_min =  0.0
const phi_max =  2π
const r_min = 0.0
const r_max =  2.0

# Диапазон направляющего угла
const α_min = -pi/2 + pi/100
const α_max = +pi/2 - pi/100
# const α_min = -pi/6
# const α_max = +pi/6

# Временной отрезок
const t_start = 0.0
const t_stop  = 5.0
# Шаг для обычного метода Рунге-Кутты
const h = 1.0e-2
# Точность для вложенного метода Рунге-Кутты
const A_tol = 1.0e-7
const R_tol = 1.0e-7

# Начальные значения
# для декартовых координат
x_0 = 1.0 
y_0 = 0.0
# Начальные значения
# для полярных координат
phi_0 = π
r_0 = 1.0
