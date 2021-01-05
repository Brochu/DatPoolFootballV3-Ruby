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
        "LA" => "Los Angeles Rams",
        "LAC" => "Los Angeles Chargers",
        "LV" => "Las Vegas Raiders",
        "OAK" => "Oakland Raiders",
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
        "WAS" => "Washington"
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
        "Los Angeles Rams" => "LA",
        "Los Angeles Chargers" => "LAC",
        "Las Vegas Raiders" => "LV",
        "Oakland Raiders" => "LV",
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
        "Washington" => "WAS",
        "Washington Redskins" => "WAS"
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
        uri = URI("https://www.thesportsdb.com/api/v1/json/1/eventsround.php")
        uri_nfl = URI("https://nflcdns.nfl.com/ajax/scorestrip?season=2020&seasonType=POST&week=18")

        # Gets the results for a given season and week
        # 01 - 17: Regular season
        # 18 - 20: Post season
        # 200: Final game (SuperBowl)

        # Some changes needed here to handle final game being round 200...
        # We need to convert week 21 to 200... saved as week 21 in my db
        params = { :id => 4391, :r => (week != "21") ? week : 200, :s => season }
        params_nfl = {
            :season => season,
            :seasonType => week.to_i < 18 ? "REG" : "POST",
            :week => (week != "21") ? week : "22"
        }
        uri.query = URI.encode_www_form(params)
        uri_nfl.query = URI.encode_www_form(params_nfl)

        res = Net::HTTP.get_response(uri)
        res_nfl = Net::HTTP.get_response(uri_nfl)

        test = Hash.from_xml(res_nfl.body)
        test = test["ss"]["gms"]["g"]
        test.each do |x|
            puts x.inspect + "\n"
        end

        return JSON.parse(res.body)
    end
end
