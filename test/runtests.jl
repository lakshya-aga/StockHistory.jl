using EconomicHistory
using Test

@testset "EconomicHistory.jl" begin
    # Write your tests here.
    @test EconomicHistory.greet_economicHistory() == "Hello EconomicHistory"
    @test EconomicHistory.greet_economicHistory() != "Hello world!"
end
