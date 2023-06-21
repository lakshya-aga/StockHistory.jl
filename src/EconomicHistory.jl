module EconomicHistory
using Pkg
Pkg.instantiate()

using DataFrames, HTTP, Dates, CSV

export greetEconomicHistory
include("functions.jl")

end
