require 'net/http'
require 'json'

# Main application controller
class ApplicationController < ActionController::Base
  @@shortname_map = {
    'ARI' => 'Arizona Cardinals',
    'ATL' => 'Atlanta Falcons',
    'BAL' => 'Baltimore Ravens',
    'BUF' => 'Buffalo Bills',
    'CAR' => 'Carolina Panthers',
    'CHI' => 'Chicago Bears',
    'CIN' => 'Cincinnati Bengals',
    'CLE' => 'Cleveland Browns',
    'DAL' => 'Dallas Cowboys',
    'DEN' => 'Denver Broncos',
    'DET' => 'Detroit Lions',
    'GB' => 'Green Bay Packers',
    'HOU' => 'Houston Texans',
    'IND' => 'Indianapolis Colts',
    'JAX' => 'Jacksonville Jaguars',
    'KC' => 'Kansas City Chiefs',
    'LA' => 'Los Angeles Rams',
    'LAC' => 'Los Angeles Chargers',
    'LV' => 'Las Vegas Raiders',
    # 'OAK' => 'Oakland Raiders',
    'MIA' => 'Miami Dolphins',
    'MIN' => 'Minnesota Vikings',
    'NE' => 'New England Patriots',
    'NO' => 'New Orleans Saints',
    'NYG' => 'New York Giants',
    'NYJ' => 'New York Jets',
    'PHI' => 'Philadelphia Eagles',
    'PIT' => 'Pittsburgh Steelers',
    'SEA' => 'Seattle Seahawks',
    'SF' => 'San Francisco 49ers',
    'TB' => 'Tampa Bay Buccaneers',
    'TEN' => 'Tennessee Titans',
    'WAS' => 'Washington'
  }

  @@longname_map = {
    'Arizona Cardinals' => 'ARI',
    'Atlanta Falcons' => 'ATL',
    'Baltimore Ravens' => 'BAL',
    'Buffalo Bills' => 'BUF',
    'Carolina Panthers' => 'CAR',
    'Chicago Bears' => 'CHI',
    'Cincinnati Bengals' => 'CIN',
    'Cleveland Browns' => 'CLE',
    'Dallas Cowboys' => 'DAL',
    'Denver Broncos' => 'DEN',
    'Detroit Lions' => 'DET',
    'Green Bay Packers' => 'GB',
    'Houston Texans' => 'HOU',
    'Indianapolis Colts' => 'IND',
    'Jacksonville Jaguars' => 'JAX',
    'Kansas City Chiefs' => 'KC',
    'Los Angeles Rams' => 'LA',
    'Los Angeles Chargers' => 'LAC',
    'Las Vegas Raiders' => 'LV',
    'Oakland Raiders' => 'LV',
    'Miami Dolphins' => 'MIA',
    'Minnesota Vikings' => 'MIN',
    'New England Patriots' => 'NE',
    'New Orleans Saints' => 'NO',
    'New York Giants' => 'NYG',
    'New York Jets' => 'NYJ',
    'Philadelphia Eagles' => 'PHI',
    'Pittsburgh Steelers' => 'PIT',
    'Seattle Seahawks' => 'SEA',
    'San Francisco 49ers' => 'SF',
    'Tampa Bay Buccaneers' => 'TB',
    'Tennessee Titans' => 'TEN',
    'Washington' => 'WAS',
    'Washington Redskins' => 'WAS'
  }

  def get_teams
    @@shortname_map.keys
  end

  def get_shortname(longname)
    @@longname_map[longname]
  end

  def get_longname(shortname)
    @@shortname_map[shortname]
  end

  def get_week(season, week)
    uri = URI("https://www.thesportsdb.com/api/v1/json/2/eventsround.php")

    # Gets the results for a given season and week
    # 01 - 17: Regular season
    # 18 - 20: Post season
    # 200: Final game (SuperBowl)

    # Special handling of round values for TheSportDB
    realWeek = week;
    #realWeek = 160 if week == '19';
    #realWeek = 170 if week == '20';
    #realWeek = 180 if week == '21';
    realWeek = 200 if week == '22';

    params = { id: 4391, r: realWeek, s: season }
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)

    output = JSON.parse(res.body)
    output['events'].each do |match|
      puts "===>#{match['strEventAlternate'].inspect}\n"
    end

    output
  end

  def get_week_name(week_num)
    n = week_num
    n = n.to_i if n.is_a? String

    return n.to_s if n < 19
    return 'WC' if n == 19
    return 'DV' if n == 20
    return 'CF' if n == 21
    return 'SB' if n == 22
  end
  helper_method :get_week_name

  def get_week_long_name(week_num)
    n = week_num
    n = n.to_i if n.is_a? String

    return "semaine %i" % [n] if n < 19
    return 'WildCards' if n == 19
    return 'Division Round' if n == 20
    return 'Conference Championship' if n == 21
    return 'SuperBowl' if n == 22
  end
  helper_method :get_week_long_name
end
