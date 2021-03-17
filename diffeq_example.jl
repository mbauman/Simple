using Distributed
# Need to add these packages
using DifferentialEquations
using Plots

# addprocs() -- don't need on JuliaRun
@everywhere using DifferentialEquations # the workers need to add them too!

# Linear ODE which starts at 0.5 and solves from t=0.0 to t=1.0
prob = ODEProblem((u,p,t)->1.01u,0.5,(0.0,1.0))

@everywhere function prob_func(prob,i,repeat)
  remake(prob,u0=rand()*prob.u0)
end

ensemble_prob = EnsembleProblem(prob,prob_func=prob_func)
sim, t = @timed solve(ensemble_prob,Tsit5(),EnsembleDistributed(),trajectories=100)

p = plot(sim,linealpha=0.4)
savefig(p, "plot.png")

ENV["OUTPUTS"] = """{
    "t": $t
}"""

ENV["RESULTS_FILE_TO_UPLOAD"] = "plot.png"
