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
      resp = http.request(req)
      body = resp.body
      if resp.code != "200"
        raise "HTTP #{resp.code}: body: #{body}"
      end
      File.write(out, body) if out
      begin
        JSON.parse(body)
      rescue JSON::ParserError => e
        raise "error parsing response body: #{body.inspect}"
      end
    end
  end
end
