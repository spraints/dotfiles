#!/usr/bin/env ruby
#
# 🌡️

require "json"
require "net/http"
require "time"

def main
  uri = URI("https://temps.pickardayune.com/")
  req = Net::HTTP::Get.new(uri)
  req["Accept"] = "application/json"

  Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    res = http.request(req)

    if res.code != "200"
      printf "🌡️❓\n---\nHTTP #{res.code}\n#{res.body}"
      return
    end

    temps = JSON.load(res.body).fetch("temps")
    outdoors = get_temp(temps, "Outdoors", "f")
    landing = get_temp(temps, "1 landing", "f")

    now = Time.now
    temps.each do |t|
      t["hours_old"] = (now - Time.parse(t["updated_at"])) / 3600.0
    end

    old, new = temps.partition { |t| t["hours_old"] > 1.0 }

    puts "🌡️ #{outdoors} F (#{landing} F 🏠)"
    puts "---"
    new.each do |t|
      puts "#{t.dig("value", "f").to_i} F - #{t["location"]}"
    end
    unless old.empty?
      puts "---"
      old.sort_by { |t| t["hours_old"] }.each do |t|
        puts "#{t.dig("value", "f").to_i} F - #{t["location"]} (#{t["hours_old"].to_i} hours ago)"
      end
    end
  end
end

def get_temp(temps, location, units)
  if data = temps.find { |t| t["location"] == location }
    data.dig("value", units).to_i
  else
    "??"
  end
end

main
