require 'selenium-webdriver'
require 'nokogiri'
require 'csv'

team_key = {
  "Cooks Me Baby One More Time" => "jerms",
  "Jaboo Coming Thru" => "jhigh",
  "Got my Siemian on Kelce" => "klo",
  "Water under the Bridgewater" => "joe",
  "In Zeke We Trust" => "dagr",
  "Mayfield's Bakery" => "woody",
  "JEFFERY" => "brock",
  "Inglorious Staffords" => "mike",
  "Jaqen Hgharoppolo" => "mcgunn",
  "Get Your Tyreek On" => "trox",
  "Hurricane Ajayi" => "kern", 
  "Greatest Show on Turf" => "dagr", 
  "The Real McCoy" => "kern", 
  "lights CAMera action" => "jhigh", 
  "Bro Flacco" => "kjemp", 
  "The Arian Brotherhood" => "mcgunn", 
  "Best in Schaub" => "jared", 
  "Occupy The Endzone" => "flack", 
  "CjCj 30mil" => "klo", 
  "Maclin on Your Girl" => "joe", 
  "Hood niggas" => "trox", 
  "Living In a Van By The Rivers" => "tim", 
  "Making Sure You Ain't Last" => "brock", 
  "McGunnigle - Motley Cruz" => "mcgunn", 
  "The Romosapiens" => "kern", 
  "ABC Easy as RGIII" => "joe", 
  "It's not just Luck" => "jhigh", 
  "RANDY MOSS THE BOSS HUUAHHHHH" => "trox", 
  "GreenGrapesWhiteWine" => "brock", 
  "Stephen's Howling in the Wayne" => "klo", 
  "Welker Texas Ranger" => "flack", 
  "One Team One Dream" => "dagr", 
  "Fuck you JHIGH" => "tim", 
  "BRO FLACCO" => "kjemp", 
  "Michael Bush League" => "jared", 
  "Shady McCoy" => "dagr", 
  "The Bush Playoff Push" => "flack", 
  "Speedo-Licious" => "joe", 
  "DeMarco Polo" => "jhigh", 
  "Teenage Newton Ninja Turtles" => "kern", 
  "The Walking Dez" => "mcgunn", 
  "Grandma's Fine Cutlery" => "brock", 
  "Hakuna Ma-Ngata" => "kjemp", 
  "Wilson and the Volleyballs" => "jared", 
  "Saved by the Bell 2013" => "klo", 
  "Saved by the Bell 2015" => "trox", 
  "Wine Her Dine Her 49er" => "tim", 
  "Cooper Clux Clan" => "trox", 
  "Switches and Bitches" => "flack", 
  "Beats by Tre" => "mcgunn", 
  "Flaccoroni and Cheese" => "kjemp", 
  "Cops and Rodgers" => "joe", 
  "Manning United FC" => "mike", 
  "Struggle City" => "dagr", 
  "Another Hillarious Season" => "brock", 
  "the full Nelson" => "klo", 
  "The Real Slim Brady" => "jhigh", 
  "The Inconvenient Truth" => "woody", 
  "Ridin Dirty in the DMC" => "dagr", 
  "Welcome to the Space Jameis" => "jhigh", 
  "Don't Vontaze Me Breaux" => "woody", 
  "Hyde your Kids Hyde your Wife" => "mcgunn", 
  "Gronk if you have RB Blues" => "joe", 
  "Valar Almorris" => "klo", 
  "Lynch Don't Kill My Vibe" => "mike", 
  "Mark Instagram It" => "brock", 
  "Edward ForteHands" => "flack", 
  "TEFLON TOM" => "kern", 
  "The Forte Year Old Virgin" => "trox", 
  "Zeke Squad" => "mike", 
  "Cam On Em 1 Time" => "jhigh", 
  "Dak to the Future" => "klo", 
  "Run LGB" => "kern", 
  "Ware and ACL Tears" => "flack", 
  "The Law Offices of Ryan n Ryan" => "woody", 
  "Cooper's Hall" => "mcgunn", 
  "Devonta FreeDatMan" => "dagr", 
  "Yippee Kai A Justin Tucker" => "kjemp"
}

teams = { "dagr" => nil,
  "brock" => nil,
  "kern" => nil,
  "klo" => nil,
  "joe" => nil,
  "mcgunn" => nil,
  "jared" => nil,
  "jhigh" => nil,
  "tim" => nil,
  "woody" => nil,
  "jerms" => nil,
  "mike" => nil,
  "kjemp" => nil,
  "flack" => nil,
  "trox" => nil,
  }

  teams.each do |k,v|
    teams[k] = { games_played: 0, wins: 0, losses: 0, pts_for: 0 }
  end


driver = Selenium::WebDriver.for :firefox


driver.navigate.to "https://www.nfl.com/login?s=fantasy&returnTo=http%3A%2F%2Ffantasy.nfl.com%2Fleague%2F400302"
sleep(1)
username = driver.find_element(id: "fanProfileEmailUsername")
password = driver.find_element(id: "fanProfilePassword")
submit = driver.find_element(xpath: "/html/body/div[1]/div/div/div[2]/div[1]/div/div/div[2]/main/div/div[2]/div[2]/form/div[3]/button")
sleep(1)
username.send_keys("brock.m.tillotson@gmail.com")
password.send_keys("rock7900")
submit.click()
sleep(5)


def get_final_standings(year, driver, team_key)
  
  driver.navigate.to "http://fantasy.nfl.com/league/400302/history/#{year}/standings"
  sleep(5)
  doc = Nokogiri::HTML(driver.page_source)
  standing_block = doc.css('#finalStandings')

  teams = standing_block.css(".teamName")

  final_standings = teams[1..12].map do |team|
    team.text
  end

  puts final_standings
end


def get_regular_standings(year, driver, team_key)
  driver.navigate.to "http://fantasy.nfl.com/league/400302/history/#{year}/standings?historyStandingsType=regular"
  sleep(5)
  doc = Nokogiri::HTML(driver.page_source)
  standing_block = doc.css('#leagueHistoryStandings')

  teams = standing_block.css(".teamName")[1..12]
  win_pct = standing_block.css(".teamWinPct").to_a.values_at(5,6,7,8,9,10,13,14,15,16,17,18)
  pts_for = standing_block.css(".teamPts").css(":not(.last)").to_a.values_at(13,14,15,16,17,18,25,26,27,28,29,30)
  pts_against = standing_block.css(".teamPts").css(".last").to_a.values_at(5,6,7,8,9,10,13,14,15,16,17,18)


  final_standings = []

  teams.each_with_index do |team, i|
    arr = [team.text, win_pct[i].text, pts_for[i].text, pts_against[i].text]
    final_standings.push(arr)
  end

  CSV.open('regular_standings.csv', "ab", force_quotes: false) do |csv|
    final_standings.each do |standing|
      puts standing[0]
      csv << [year, team_key[standing[0]], standing[1].to_f, standing[2], standing[3].gsub( /"/, "")]
    end
  end


end


def get_playoff_games(year, driver, team_key, teams)

  driver.navigate.to "http://fantasy.nfl.com/league/400302/history/#{year}/playoffs"
  sleep(5)
  doc = Nokogiri::HTML(driver.page_source)
  
  qf_game_1 = doc.css(".pw-0").css(".pg-1")
  qf_game_2 = doc.css(".pw-0").css(".pg-2")

  sf_game_1 = doc.css(".pw-1").css(".pg-0")
  sf_game_2 = doc.css(".pw-1").css(".pg-1")
  
  final_game = doc.css(".pw-2").css(".pg-0")

  def get_results(game, teams, team_key, year)
    player_1 = game.css(".teamName")[0].text
    player_1_score = game.css(".teamTotal")[0].text.to_f

    player_2 = game.css(".teamName")[1].text
    player_2_score = game.css(".teamTotal")[1].text.to_f

    if player_1 == "Saved by the Bell"
      if year == 2013
        player_1 = "Saved by the Bell 2013"
      elsif year == 2015
        player_1 = "Saved by the Bell 2015"
      end
    end


    if player_2 == "Saved by the Bell"
      if year == 2013
        player_2 = "Saved by the Bell 2013"
      elsif year == 2015
        player_2 = "Saved by the Bell 2015"
      end
    end

    if player_1_score > player_2_score
      teams[team_key[player_1]][:games_played] += 1
      teams[team_key[player_1]][:wins] += 1
      teams[team_key[player_1]][:pts_for] += player_1_score

      teams[team_key[player_2]][:games_played] += 1
      teams[team_key[player_2]][:losses] += 1
      teams[team_key[player_2]][:pts_for] += player_2_score
    else
      teams[team_key[player_2]][:games_played] += 1
      teams[team_key[player_2]][:wins] += 1
      teams[team_key[player_2]][:pts_for] += player_2_score

      teams[team_key[player_1]][:games_played] += 1
      teams[team_key[player_1]][:losses] += 1
      teams[team_key[player_1]][:pts_for] += player_1_score
    end

    teams
  end

  get_results(qf_game_1, teams, team_key, year)
  get_results(qf_game_2, teams, team_key, year)
  get_results(sf_game_1, teams, team_key, year)
  get_results(sf_game_2, teams, team_key, year)
  get_results(final_game, teams, team_key, year)

  return teams
end


def get_full_years_games(year, driver, team_key, teams)

  
  def get_one_game(year, team_id, week, driver)

    driver.navigate.to "http://fantasy.nfl.com/league/400302/history/#{year}/teamgamecenter?teamId=#{team_id}&week=#{week}#"
    sleep(5)
    doc = Nokogiri::HTML(driver.page_source)

    team_pane = doc.css(".teamWrap-1")
    
    starters = {
      qb_0: team_pane.css(".player-QB-0"),
      rb_0: team_pane.css(".player-RB-0"),
      rb_1: team_pane.css(".player-RB-1"),
      wr_0: team_pane.css(".player-WR-0"),
      wr_1: team_pane.css(".player-WR-1"),
      te_0: team_pane.css(".player-TE-0"),
      op_0: team_pane.css(".player-Q/R/W/T-0"),
      def_0: team_pane.css(".player-DEF-0"),
      k_0: team_pane.css(".player-K-0")
    }

    game_stats = {}

    starters.each do |k,v|
      if v.length > 0
        game_stats[k] = {
          name: v.css(".playerName").text,
          id: v.css(".playerName")[0]["href"][/(?<=playerId=)(.*)/],
          pts: v.css(".playerTotal").text
        }
      end
    end
    
    game_stats
  end
  
  puts get_one_game(2017, 1, 1, driver)

end

years = [2011, 2012, 2013, 2014, 2015, 2016, 2017]

get_full_years_games(2017, driver, team_key, teams)

driver.quit
