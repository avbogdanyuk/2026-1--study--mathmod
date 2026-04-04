# Лабораторная работа №4
# Случай 3: Колебания гармонического осциллятора с затуханием и под действием внешней силы
# Уравнение: x'' + 3.3x' + 0.1x = 0.1*sin(3t)

using DifferentialEquations
using Plots

# Параметры
const x0 = 0.1
const y0 = -1.1
const a = 0.1          # коэффициент при x
const b = 3.3          # коэффициент при x' (2γ)
const c = 0.1          # коэффициент при x (ω₀²)
const A = 0.1          # амплитуда внешней силы
const omega_f = 3.0    # частота внешней силы

# Временной интервал
T = (0.0, 46.0)

# Вектор начальных условий
u0 = [x0, y0]

# Параметры для передачи в функцию
params = (b=b, c=c, A=A, omega_f=omega_f)

# Функция внешней силы P(t) = A * sin(omega_f * t)
P(t) = A * sin(omega_f * t)

# Функция правой части системы
# du[1] = dx/dt = y
# du[2] = dy/dt = P(t) - b*y - c*x
function forced_damped_oscillator!(du, u, p, t)
    b, c, A, omega_f = p
    du[1] = u[2]
    du[2] = A*sin(omega_f*t) - b*u[2] - c*u[1]
end

# Решение
prob = ODEProblem(forced_damped_oscillator!, u0, T, params)
sol = solve(prob, dtmax=0.05)

# Фазовый портрет (y от x)
plt_phase = plot(sol, vars=(2,1),
    color=:red,
    label="Фазовый портрет",
    title="Случай 3: вынужденные колебания с затуханием",
    xlabel="x (смещение)",
    ylabel="y = dx/dt (скорость)",
    linewidth=1.5,
    legend=:topright)

# График x(t)
plt_x = plot(sol, vars=(0,1),
    color=:blue,
    label="x(t)",
    title="Вынужденные колебания x(t)",
    xlabel="Время t",
    ylabel="x (смещение)",
    linewidth=1.5)

# График скорости y(t) на том же рисунке
plot!(plt_x, sol, vars=(0,2),
    color=:green,
    label="y(t) = dx/dt",
    linewidth=1.5)

# Отдельный график для внешней силы
t_vals = 0:0.05:46
force_vals = A * sin.(omega_f * t_vals)
plt_force = plot(t_vals, force_vals,
    color=:purple,
    label="P(t) = $(A)*sin($(omega_f)t)",
    title="Внешняя сила",
    xlabel="Время t",
    ylabel="P(t)",
    linewidth=1.5)

# Сохранение графиков
savefig(plt_phase, "case3_phase.png")
savefig(plt_x, "case3_time.png")
savefig(plt_force, "case3_force.png")

# Вывод информации
println("Лабораторная работа №4 - Случай 3")
println("Уравнение: x'' + $(b)x' + $(c)x = $(A)*sin($(omega_f)t)")
println("Начальные условия: x0 = $x0, y0 = $y0")
println("Временной интервал: [0, 46], шаг = 0.05")
println()
println("Графики сохранены:")
println("  - case3_phase.png  (фазовый портрет)")
println("  - case3_time.png   (x(t) и y(t))")
println("  - case3_force.png  (внешняя сила P(t))")

# Дополнительный анализ: установившийся режим
# Отбрасываем переходный процесс (первые 30 секунд)
steady_start = findfirst(t -> t >= 30, sol.t)
if steady_start !== nothing
    # Амплитуда установившихся колебаний
    x_steady = [u[1] for u in sol.u[steady_start:end]]
    amplitude = (maximum(x_steady) - minimum(x_steady)) / 2
    println()
    println("Анализ установившегося режима (t ≥ 30):")
    println("  Амплитуда колебаний: $(round(amplitude, digits=4))")
    println("  Частота внешней силы: $(omega_f) рад/с")
    println("  Собственная частота: $(round(sqrt(c), digits=4)) рад/с")
end
