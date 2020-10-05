require 'net/http'
require 'json'

class ApplicationController < ActionController::Base
    @@shortname_map = {
        "ARI" => "Arizona Cardinals",
        "ATL" => "Atlanta Falcons",
        "BAL" => "Baltimore Ravens",
        "BUF" => "Buffalo Bills",
        "CAR" => "Carolina Panthers",
        "CHI" => "Chicago Bears",
        "CIN" => "Cincinnati Bengals",
        "CLE" => "Cleveland Browns",
        "DAL" => "Dallas Cowboys",
        "DEN" => "Denver Broncos",
        "DET" => "Detroit Lions",
        "GB" => "Green Bay Packers",
        "HOU" => "Houston Texans",
        "IND" => "Indianapolis Colts",
        "JAX" => "Jacksonville Jaguars",
        "KC" => "Kansas City Chiefs",
        "LA" => "Las Angeles Rams",
        "LAC" => "Los Angeles Chargers",
        "LV" => "Las Vegas Raiders",
        "MIA" => "Miami Dolphins",
        "MIN" => "Minnesota Vikings",
        "NE" => "New England Patriots",
        "NO" => "New Orleans Saints",
        "NYG" => "New York Giants",
        "NYJ" => "New York Jets",
        "PHI" => "Philadelphia Eagles",
        "PIT" => "Pittsburgh Steelers",
        "SEA" => "Seattle Seahawks",
        "SF" => "San Francisco 49ers",
        "TB" => "Tampa Bay Buccaneers",
        "TEN" => "Tennessee Titans",
        "WAS" => "Washington Football Team"
    }

    @@longname_map = {
        "Arizona Cardinals" => "ARI",
        "Atlanta Falcons" => "ATL",
        "Baltimore Ravens" => "BAL",
        "Buffalo Bills" => "BUF",
        "Carolina Panthers" => "CAR",
        "Chicago Bears" => "CHI",
        "Cincinnati Bengals" => "CIN",
        "Cleveland Browns" => "CLE",
        "Dallas Cowboys" => "DAL",
        "Denver Broncos" => "DEN",
        "Detroit Lions" => "DET",
        "Green Bay Packers" => "GB",
        "Houston Texans" => "HOU",
        "Indianapolis Colts" => "IND",
        "Jacksonville Jaguars" => "JAX",
        "Kansas City Chiefs" => "KC",
        "Las Angeles Rams" => "LA",
        "Los Angeles Chargers" => "LAC",
        "Las Vegas Raiders" => "LV",
        "Miami Dolphins" => "MIA",
        "Minnesota Vikings" => "MIN",
        "New England Patriots" => "NE",
        "New Orleans Saints" => "NO",
        "New York Giants" => "NYG",
        "New York Jets" => "NYJ",
        "Philadelphia Eagles" => "PHI",
        "Pittsburgh Steelers" => "PIT",
        "Seattle Seahawks" => "SEA",
        "San Francisco 49ers" => "SF",
        "Tampa Bay Buccaneers" => "TB",
        "Tennessee Titans" => "TEN",
        "Washington Football Team" => "WAS"
    }

    def get_teams
        return @@shortname_map.keys
    end

    def get_shortname(longname)
        return @@longname_map[longname]
    end

    def get_longname(shortname)
        return @@shortname_map[shortname]
    end

    def get_week(season, week)
        # Gets the results for a given season and week
        # 01 - 17: Regular season
        # 18 - 21: Post season
        uri = URI("https://www.thesportsdb.com/api/v1/json/1/eventsround.php")
        params = { :id => 4391, :r => week, :s => season }
        uri.query = URI.encode_www_form(params)

        res = Net::HTTP.get_response(uri)
        return JSON.parse(res.body)
    end
end
