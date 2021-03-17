using Distributed

@everywhere function throw_dart()
    x, y = rand(), rand()
    return Int(x^2 + y^2 < 1)
end

function estimate_pi(n)
    r = @distributed (+) for i in 1:n
        throw_dart()
    end
    return 4*r/n
end

# estimate_pi(100_000_000)
n = 100_000_000_000
pi_estimate, t = @timed estimate_pi(n)

@show pi_estimate

ENV["OUTPUTS"] = """{
    "summary": "test #1",
    "n": $n,
    "pi": $pi_estimate,
    "time": $t
}"""
