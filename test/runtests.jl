using StockHistory
using Test

@testset "StockHistory.jl" begin
    # Write your tests here.
    @test StockHistory.greet_stockHistory() == "Hello StockHistory"
    @test StockHistory.greet_stockHistory() != "Hello world!"
end
