require "json"
require "net/http"
require "timeout"

def get_data(token:, query:, variables: {}, out: nil)
  request = {query: query, variables: variables}

  req = Net::HTTP::Post.new("https://api.github.com/graphql")
  req["Authorization"] = "token #{token}"
  req.body = JSON.dump(request)

  Timeout.timeout(30.0) do
    Net::HTTP.start("api.github.com", 443, use_ssl: true) do |http|
      body = http.request(req).body
      File.write(out, body) if out
      JSON.parse(body)
    end
  end
end
