# импорт библиотек
import Pkg; Pkg.add("PyPlot")
using Surrogates
using PyPlot
using DelimitedFiles

function array2tuple(a::Array)
	(a...,)
end

# функция отрисовки круга, изображающего линзу
function Circle(r,k,a)
	th = Array(0:2*pi/100:2*pi+2*pi/100) # theta from 0 to 2pi ( + a little extra)
	X_cir = r*k*cos.(th).+a
	Y_cir = r*k*sin.(th)
	plot(X_cir,Y_cir)
end

# загрузка данных из файлов
file_x = open("Luneburg_data/data_x.txt", "r")
df_X = readdlm(file_x, ',', Float64)

file_y = open("Luneburg_data/data_y.txt", "r")
df_Y = readdlm(file_y, ',', Float64)

# отрисовка хода лучей по исходным данным
fig01 = PyPlot.figure(1, dpi=300, figsize=(10,5))
ax01 = fig01.add_subplot(1,1,1)
ax01.plot(df_X', df_Y',color="gray",linewidth=0.5)
Circle(1,1,2)
ax01.set_xlabel("x")
ax01.set_ylabel("y")
ax01.set_title("Траектории по исходным данным")

# выбор точек для обучения
train_X=selectdim(df_X, 2, [2,25,50,75,100,150,200,300,400,500])
train_Y =selectdim(df_Y, 2,[2,25,50,75,100,150,200,300,400,500])

# построение суррогатной модели методом кригинга
lower_bound=1
upper_bound=4
Y_sur_1=[]

X=[]
Y=[]
for i = 1:50
	N=i
	kriging_surrogat = Kriging(train_X[N,:], train_Y[N,:], lower_bound, upper_bound)
	push!(Y_sur_1, kriging_surrogat.(df_X[N,:]))
	push!(X, df_X[N,:])
	push!(Y, df_Y[N,:])
end

fig02 = PyPlot.figure(2, dpi=300, figsize=(10,5))
ax02 = fig02.add_subplot(1,1,1)
for (x, y_sur) in zip(X, Y_sur_1)
	ax02.plot(x, y_sur, color="gray",linewidth=0.5)
end
Circle(1,1,2)
ax02.set_xlabel("x")
ax02.set_ylabel("y")
ax02.set_title("Траектории по методу Kriging")

# построение суррогатной модели методом GEK
lower_bound=1
upper_bound=4
Y_sur_0=[]
X=[]
Y=[]

for i = 1:50
	N=i
	my_gek = GEK(train_X[N,:], train_Y[N,:], lower_bound, upper_bound)
	push!(Y_sur_0, my_gek.(df_X[N,:]))
	push!(X, df_X[N,:])
	push!(Y, df_Y[N,:])
end

fig02 = PyPlot.figure(2, dpi=300, figsize=(10,5))
ax02 = fig02.add_subplot(1,1,1)
for (x, y_sur) in zip(X, Y_sur_0)
	ax02.plot(x, y_sur, color="gray",linewidth=0.5)
end
Circle(1,1,2)
ax02.set_xlabel("x")
ax02.set_ylabel("y")
ax02.set_title("Траектории по методу GEK")

# построение суррогатной модели методом полинома 2-го порядка
lower_bound=1
upper_bound=4
Y_sur_2=[]

for i = 1:50
	N=i
	Sec = SecondOrderPolynomialSurrogate(train_X[N,:], train_Y[N,:], lower_bound, upper_bound)#, p=[1.9, 1.9, 1.9]);
	push!(Y_sur_2, Sec.(df_X[N,:]))
end

fig02 = PyPlot.figure(2, dpi=300, figsize=(10,5))
ax02 = fig02.add_subplot(1,1,1)
for (x, y_sur) in zip(X, Y_sur_2)
	ax02.plot(x, y_sur, color="gray",linewidth=0.5)
	#ax02.plot(train_X', train_Y',color="gray")
end
Circle(1,1,2)
ax02.set_xlabel("x")
ax02.set_ylabel("y")
ax02.set_title("Траектории по методу полинома 2-го порядка")
# построение суррогатной модели методом Лобачевского
lower_bound=1
upper_bound=4

Y_sur_3=[]
for i = 1:50
	N=i
	Lobachevsky = LobachevskySurrogate(train_X[N,:], train_Y[N,:], lower_bound, upper_bound)
	push!(Y_sur_3, Lobachevsky.(df_X[N,:]))
end

fig02 = PyPlot.figure(2, dpi=300, figsize=(10,5))
ax02 = fig02.add_subplot(1,1,1)
for (x, y_sur) in zip(X, Y_sur_3)
	ax02.plot(x, y_sur, color="gray",linewidth=0.5)
end
Circle(1,1,2)
ax02.set_xlabel("x")
ax02.set_ylabel("y")
ax02.set_title("Траектории по методу Лобачевского")

# построение суррогатной модели методом обратных взвешенных расстояний
lower_bound=1
upper_bound=4

Y_sur_4=[]

for i = 1:50
	N=i
	InverseDistance = InverseDistanceSurrogate(train_X[N,:], train_Y[N,:], lower_bound, upper_bound)#, p=[1.9, 1.9, 1.9]);
	push!(Y_sur_4, InverseDistance.(df_X[N,:]))
end

fig02 = PyPlot.figure(2, dpi=300, figsize=(10,5))
ax02 = fig02.add_subplot(1,1,1)
for (x, y_sur) in zip(X, Y_sur_4)
	ax02.plot(x, y_sur, color="gray",linewidth=0.5)
	#ax02.plot(train_X', train_Y',color="gray")
end
Circle(1,1,2)
ax02.set_xlabel("x")
ax02.set_ylabel("y")
ax02.set_title("Траектории по методу обратных расстояний")

# построение суррогатной модели радиально-базисным методом
lower_bound=1
upper_bound=4

Y_sur_0=[]
X=[]
Y=[]

for i = 1:50
	N=i
	my_gek = RadialBasis(train_X[N,:], train_Y[N,:], lower_bound, upper_bound)#, p=[1.9, 1.9, 1.9]);
	push!(Y_sur_0, my_gek.(df_X[N,:]))
	push!(X, df_X[N,:])
	push!(Y, df_Y[N,:])
end

fig02 = PyPlot.figure(2, dpi=300, figsize=(10,5))
ax02 = fig02.add_subplot(1,1,1)
for (x, y_sur) in zip(X, Y_sur_0)
	ax02.plot(x, y_sur, color="gray",linewidth=0.5)
	#ax02.plot(train_X', train_Y',color="gray")
end
Circle(1,1,2)
ax02.set_xlabel("x")
ax02.set_ylabel("y")
ax02.set_title("RadialBasis")

# построение суррогатной модели линейным методом
lower_bound=1
upper_bound=4

Y_sur_5=[]

for i = 1:50
	N=i
	Linear = LinearSurrogate(train_X[N,:], train_Y[N,:], lower_bound, upper_bound)#, p=[1.9, 1.9, 1.9]);
	push!(Y_sur_5, Linear.(df_X[N,:]))
	push!(X, df_X[N,:])
	push!(Y, df_Y[N,:])
end

fig02 = PyPlot.figure(2, dpi=300, figsize=(10,5))
ax02 = fig02.add_subplot(1,1,1)
for (x, y_sur) in zip(X, Y_sur_5)
	ax02.plot(x, y_sur, color="gray",linewidth=0.5)
	#ax02.plot(train_X', train_Y',color="gray")
end
Circle(1,1,2)
ax02.set_xlabel("x")
ax02.set_ylabel("y")
ax02.set_title("Траектории по линейному методу")

# подсчет абсолютных ошибок
ERROR_1=[]
ERROR_2=[]
ERROR_3=[]
ERROR_4=[]
ERROR_5=[]

NN=[]

for i = 1:50
	push!(NN, i)
	push!(ERROR_1, abs.(sum.(Y_sur_1[i,:])/50 - sum.(Y[i,:])/50))
	push!(ERROR_2, abs.(sum.(Y_sur_2[i,:])/50 - sum.(Y[i,:])/50))
	push!(ERROR_3, abs.(sum.(Y_sur_3[i,:])/50 - sum.(Y[i,:])/50))
	push!(ERROR_4, abs.(sum.(Y_sur_4[i,:])/50 - sum.(Y[i,:])/50))
	push!(ERROR_5, abs.(sum.(Y_sur_5[i,:])/50 - sum.(Y[i,:])/50))
end

# визуализация для сравнения абсолютных ошибок
fig03 = PyPlot.figure(3, dpi=300, figsize=(10,5))
ax03 = fig03.add_subplot(1,1,1)
#for (n, err) in zip(NN, ERROR)
ax03.plot(NN, ERROR_1, label="Kriging")#, color="k")
ax03.plot(NN, ERROR_2, label="Second order polynomial")#, color="gray")
ax03.plot(NN, ERROR_3, label="Lobachevsky")#, color="gray")
ax03.plot(NN, ERROR_4, label="InverseDistance")#, color="gray")
ax03.plot(NN, ERROR_5, label="Linera")#, color="gray")

ax03.set_xlabel("Номер луча")
ax03.set_ylabel("Ошибка")
ax03.set_title("Абсолютная ошибка, средняя по лучу")
ax03.legend(loc="best")

# сравнение кригинга в Julia и Python
fig04 = PyPlot.figure(3, dpi=300, figsize=(10,5))
ax04 = fig04.add_subplot(1,1,1)
#for (n, err) in zip(NN, ERROR)
ax04.plot(NN, ERROR_1, label="Julia")
ax04.plot(NN, er_py_1, label="Python")
ax04.set_xlabel("Номер луча")
ax04.set_ylabel("Ошибка")
ax04.set_title("Абсолютная ошибка для метода Kriging")
ax04.legend(loc="best")

# сравнение линейного метода в Julia и Python
fig05 = PyPlot.figure(3, dpi=300, figsize=(10,5))
ax05 = fig05.add_subplot(1,1,1)
#for (n, err) in zip(NN, ERROR)
ax05.plot(NN, ERROR_5, label="Julia")
ax05.plot(NN, er_py_5, label="Python")
ax05.set_xlabel("Номер луча")
ax05.set_ylabel("Ошибка")
ax05.set_title("Абсолютная ошибка для линейного метода")
ax05.legend(loc="best")

# сравнение метода обратных взвешенных расстояний в Julia и Python
fig06 = PyPlot.figure(3, dpi=300, figsize=(10,5))
ax06 = fig06.add_subplot(1,1,1)
#for (n, err) in zip(NN, ERROR)
ax06.plot(NN, ERROR_4, label="Julia")
ax06.plot(NN, er_py_4, label="Python")
ax06.set_xlabel("Номер луча")
ax06.set_ylabel("Ошибка")
ax06.set_title("Абсолютная ошибка для метода обратных взвешенных расстояний")
ax06.legend(loc="best")