# Случай 2: Колебания гармонического осциллятора с затуханием
# Уравнение: x'' + 0.8x' + 3x = 0

using DifferentialEquations
using Plots

# Параметры
const x0 = 0.1
const y0 = -1.1
const omega_sq = 3.0
const gamma = 0.4        # 2γ = 0.8 ⇒ γ = 0.4
T = (0.0, 46.0)
u0 = [x0, y0]
params = (omega_sq, gamma)

# Функция правой части
function damped_oscillator!(du, u, p, t)
    omega_sq, gamma = p
    du[1] = u[2]
    du[2] = -2*gamma*u[2] - omega_sq*u[1]
end

# Решение
prob = ODEProblem(damped_oscillator!, u0, T, params)
sol = solve(prob, dtmax=0.05)

# Визуализация
plt_phase = plot(sol, vars=(2,1), color=:red,
    label="Фазовый портрет",
    title="Случай 2: затухающие колебания (γ = $gamma, ω₀² = $omega_sq)",
    xlabel="x", ylabel="dx/dt", linewidth=2)

plt_time = plot(sol, vars=(0,1), color=:blue,
    label="x(t)", title="Затухающие колебания x(t)",
    xlabel="t", ylabel="x", linewidth=2)
plot!(plt_time, sol, vars=(0,2), color=:green,
    label="dx/dt", linewidth=2)

# Сохранение
savefig(plt_phase, "case2_phase.png")
savefig(plt_time, "case2_time.png")

println("Графики сохранены: case2_phase.png и case2_time.png")
println("\nПараметры системы:")
println("  ω₀² = $omega_sq")
println("  ω₀ = $(round(sqrt(omega_sq), digits=3))")
println("  γ = $gamma")
println("  Режим: слабое затухание (γ < ω₀)")
