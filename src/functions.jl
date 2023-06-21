
function greet_economicHistory()
    return "Hello EconomicHistory"
end

function get_history(symbol::String, API_KEY::String, attribute::String)
    url = "https://www.alphavantage.co/query"
    params = [
        "function" => "TIME_SERIES_MONTHLY_ADJUSTED",
        "apikey" => API_KEY,
        "symbol" => symbol,
        "outputsize" => "full",
        "datatype" => "csv"
    ]
    response = HTTP.get(url, query=params)
    df = CSV.File(IOBuffer(response.body)) |> DataFrame
    history = df[!, [:"timestamp", attribute]]
    rename!(history, attribute => symbol)
    sort!(history, :timestamp)
    return history
end

function get_economy_history(indicator::String, API_KEY::String)
    url = "https://www.alphavantage.co/query"
    params = [
        "function" => indicator,
        "apikey" => API_KEY,
        "datatype" => "csv"
    ]
    response = HTTP.get(url, query=params)
    df = CSV.File(IOBuffer(response.body)) |> DataFrame
    df = df[!, [:timestamp, :value]]
    rename!(df, :value => indicator)
    sort!(df, :timestamp)
    return df
end

function get_history_returns(symbol, API_KEY, attribute)
    url = "https://www.alphavantage.co/query"
    params = [
        "function" => "TIME_SERIES_MONTHLY_ADJUSTED",
        "apikey" => API_KEY,
        "symbol" => symbol,
        "outputsize" => "full",
        "datatype" => "csv"
    ]
    response = HTTP.get(url, query=params)
    df = CSV.File(IOBuffer(response.body)) |> DataFrame
    len = size(df)[1]
    df[:,attribute] .= 0.0
    df[1:len-1,attribute] = df[1:len-1, "adjusted close"]./df[2:len, "adjusted close"].-1
    history = df[!, [:"timestamp", attribute]]
    rename!(history, attribute => symbol*"_"*attribute)
    sort!(history, :timestamp)
    return history
end

function get_history_log_returns(symbol, API_KEY, attribute)
    url = "https://www.alphavantage.co/query"
    params = [
        "function" => "TIME_SERIES_MONTHLY_ADJUSTED",
        "apikey" => API_KEY,
        "symbol" => symbol,
        "outputsize" => "full",
        "datatype" => "csv"
    ]
    response = HTTP.get(url, query=params)
    df = CSV.File(IOBuffer(response.body)) |> DataFrame
    len = size(df)[1]
    df[:,attribute] .= 0.0
    df[1:len-1,attribute] = log.(df[1:len-1, "adjusted close"]./df[2:len, "adjusted close"])
    history = df[!, [:"timestamp", attribute]]
    rename!(history, attribute => symbol*"_"*attribute)
    sort!(history, :timestamp)
    return history
end


field2func = Dict(
    "open" => get_history,
    "high" => get_history,
    "low" => get_history,
    "close" => get_history,
    "adjusted close" => get_history,
    "volume" => get_history,
    "dividend" => get_history,
    "log returns" => get_history_log_returns,
    "returns" => get_history_returns,
    )


function get_history(tickers::Vector{String}, apikey::String, field::String)
    n = length(tickers)
    if n == 1
        return field2func[field](tickers[1], apikey, field)
    end
    tmp = []
    for i in 1:n
        push!(tmp, field2func[field](tickers[i], apikey, field))
        if(n%5==0)
            println("Limit is 5 API calls per minute. Suspending for 50 seconds")
            sleep(50)
        end
    end
    d = tmp[1]
    for i = 2:n
        d = innerjoin(d, tmp[i], on=:timestamp)
    end
    dropmissing!(d)
    return d
end

function get_economy_history(indicators::Vector{String}, apikey::String)
    n = length(indicators)
    if n == 1
        return get_economy_history(indicators[1], apikey)
    end
    tmp = []
    for i in 1:n
        push!(tmp, get_economy_history(indicators[i], apikey))
        if(n%5==0)
            println("Limit is 5 API calls per minute. Suspending for 50 seconds")
            sleep(30)
        end
    end
    d = tmp[1]
    for i = 2:n
        d = innerjoin(d, tmp[i], on=:timestamp)
    end
    dropmissing!(d)
    return d
end

### Usage Examples
# indicators = ["CPI","TREASURY_YIELD"]

# data = get_economy_history(indicators, "WLLVVYKMEIA2BS91")

