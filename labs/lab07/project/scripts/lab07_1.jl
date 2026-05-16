using Plots

const N = 945
const N0 = 13.0

function euler_solve(f, u0, tspan, dt)
    t = tspan[1]:dt:tspan[2]
    u = zeros(length(t))
    u[1] = u0[1]
    
    for i in 1:length(t)-1
        du = zeros(1)
        f(du, [u[i]], nothing, t[i])
        u[i+1] = u[i] + dt * du[1]
    end
    
    return t, u
end

# Case 1
function F1(du, u, p, t)
    du[1] = (0.51 + 0.000099*u[1])*(N - u[1])
end

t1, u1 = euler_solve(F1, [N0], (0.0, 30.0), 0.1)
plt1 = plot(t1, u1, color=:red, title="Распространение рекламы, 1 случай", 
            legend=false, xlabel="t", ylabel="N(t)", linewidth=2)
savefig(plt1, "lab07_1.png")

max_val = -10000.0
max_time = 0.0

function F2(du, u, p, t)
    du[1] = (0.000019 + 0.99*u[1])*(N - u[1])
    
    if du[1] > max_val
        global max_val, max_time
        max_val = du[1]
        max_time = t
    end
end

t2, u2 = euler_solve(F2, [N0], (0.0, 0.2), 0.0001)
println("Maximum derivative at t = ", max_time)

plt2 = plot(t2, u2, color=:red, title="Распространение рекламы, 2 случай", 
            legend=false, xlabel="t", ylabel="N(t)", linewidth=2)
savefig(plt2, "lab07_2.png")

function F3(du, u, p, t)
    du[1] = (0.99*t + 0.3*cos(4*t)*u[1])*(N - u[1])
end

t3, u3 = euler_solve(F3, [N0], (0.0, 0.2), 0.0001)
plt3 = plot(t3, u3, color=:red, title="Распространение рекламы, 3 случай", 
            legend=false, xlabel="t", ylabel="N(t)", linewidth=2)
savefig(plt3, "lab07_3.png")
