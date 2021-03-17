using Distributed
using DifferentialEquations
using Plots
ENV["GKSwstype"] = "nul"

@everywhere using DifferentialEquations
prob = ODEProblem((u,p,t)->1.01u,0.5,(0.0,1.0))
@everywhere function prob_func(prob,i,repeat)
  remake(prob,u0=rand()*prob.u0)
end
ensemble_prob = EnsembleProblem(prob,prob_func=prob_func)
sim = solve(ensemble_prob,Tsit5(),EnsembleDistributed(),trajectories=100)
p = plot(sim,linealpha=0.4)

savefig(p, "plot.png")
ENV["RESULTS_FILE_TO_UPLOAD"] = "plot.png"
