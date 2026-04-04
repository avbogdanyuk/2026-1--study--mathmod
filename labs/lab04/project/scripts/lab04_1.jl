# Случай 1: Колебания гармонического осциллятора без затуханий
# Уравнение: x'' + 1.5x = 0

using DifferentialEquations
using Plots

# Параметры
const x0 = 0.1
const y0 = -1.1
const omega_sq = 1.5
T = (0.0, 46.0)
u0 = [x0, y0]

# Функция правой части
function harmonic_oscillator!(du, u, p, t)
    omega_sq = p
    du[1] = u[2]
    du[2] = -omega_sq * u[1]
end

# Решение
prob = ODEProblem(harmonic_oscillator!, u0, T, omega_sq)
sol = solve(prob, dtmax=0.05)

# Визуализация
plt_phase = plot(sol, vars=(2,1), color=:red,
    label="Фазовый портрет",
    title="Случай 1: колебания без затухания",
    xlabel="x", ylabel="dx/dt", linewidth=2)

plt_time = plot(sol, vars=(0,1), color=:blue,
    label="x(t)", title="Решение x(t)",
    xlabel="t", ylabel="x", linewidth=2)
plot!(plt_time, sol, vars=(0,2), color=:green,
    label="dx/dt", linewidth=2)

# Сохранение
savefig(plt_phase, "case1_phase.png")
savefig(plt_time, "case1_time.png")

println("Графики сохранены: case1_phase.png и case1_time.png")
