using OrdinaryDiffEq, Plots

# Параметры
N = 10850
I0 = 209
R0 = 42
S0 = N - I0 - R0

α = 0.01
β = 0.02
I_star = 250

# Случай 1: I(0) ≤ I*
function sir_leq(u, p, t)
    S, I, R = u
    dS = 0.0
    dI = -β * I
    dR = β * I
    return [dS, dI, dR]
end

# Случай 2: I(0) > I*
function sir_gt(u, p, t)
    S, I, R = u
    dS = -α * S
    dI = α * S - β * I
    dR = β * I
    return [dS, dI, dR]
end

u0 = [S0, I0, R0]
tspan = (0.0, 200.0)

# Решаем отдельно для двух случаев
prob_leq = ODEProblem(sir_leq, u0, tspan)
sol_leq = solve(prob_leq, Tsit5(), saveat=0.5)

prob_gt = ODEProblem(sir_gt, u0, tspan)
sol_gt = solve(prob_gt, Tsit5(), saveat=0.5)

# Визуализация
p1 = plot(sol_leq.t, sol_leq[1,:], label="S(t) - Восприимчивые", lw=2)
plot!(p1, sol_leq.t, sol_leq[2,:], label="I(t) - Инфицированные", lw=2)
plot!(p1, sol_leq.t, sol_leq[3,:], label="R(t) - С иммунитетом", lw=2)
title!(p1, "Случай: I(0) ≤ I* (I(0)=$I0, I*=$I_star)")
xlabel!(p1, "Время")
ylabel!(p1, "Численность")

p2 = plot(sol_gt.t, sol_gt[1,:], label="S(t) - Восприимчивые", lw=2)
plot!(p2, sol_gt.t, sol_gt[2,:], label="I(t) - Инфицированные", lw=2)
plot!(p2, sol_gt.t, sol_gt[3,:], label="R(t) - С иммунитетом", lw=2)
title!(p2, "Случай: I(0) > I* (I(0)=$I0, I*=$I_star)")
xlabel!(p2, "Время")
ylabel!(p2, "Численность")

plot(p1, p2, layout=(1,2), size=(1000, 400))

println("Максимум инфицированных (случай 2): ", maximum(sol_gt[2,:]))
println("Анализ: I(0)=$I0, I*=$I_star")
if I0 <= I_star
    println("I(0) ≤ I* → эпидемия не развивается")
else
    println("I(0) > I* → происходит вспышка эпидемии")
end

savefig(p1, "SIR_I_less.png")
savefig(p2, "SIR_I_more.png")