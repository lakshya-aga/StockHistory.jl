# StockHistory

[![Build Status](https://github.com/lakshya-aga/StockHistory.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/lakshya-aga/StockHistory.jl/actions/workflows/CI.yml?query=branch%3Amain)

To use:
Pkg.add("StockHistory")

get_history(tickers::Vector{String}, apikey::String, field::String)
pass the Strings as a vector of ticker symbols. pass API_key as argument. Note: we are using the free API only so there is a limit to number of API calls per minute. eg. ["AAPL", "GOOG"]
Field can take values ["open", "high", "low", "close", "adjusted close", "volume", "dividend", "log returns", "returns"]


get_economy_history(indicators::Vector{String}, apikey::String)
Indicators can be any on the indicators on AlphaVantage
eg usage: get_economy_history(["CPI","Treasury_yield"], key)
