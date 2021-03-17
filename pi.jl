using Distributed

function monte_carlo_pi(n)
    for i in 1:n
        x, y = rand(), rand()
        x^2 + y^2 < 1
    end
    return 4*r/n
end

pi, t = @timed monte_carlo_pi(10000000000)

ENV["OUTPUTS"] = """{
    "pi": $pi,
    "time": $t
}"""
