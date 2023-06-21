using EconomicHistory
using Test

@testset "EconomicHistory.jl" begin
    # Write your tests here.
    @test EconomicHistory.greet_your_package_name() == "Hello EconomicHistory"
    @test EconomicHistory.greet_your_package_name() != "Hello world!"
end
