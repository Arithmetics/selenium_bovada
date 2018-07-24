require 'selenium-webdriver'
require 'nokogiri'
require './email.rb'


############### NFL Game Lines ###############
def get_football_lines

  driver = Selenium::WebDriver.for :firefox
  driver.manage.window.minimize

  driver.navigate.to "https://www.bovada.lv"

  driver.find_element(xpath: "/html/body/bx-site/ng-component/bx-header-ch/div/nav/ul/li[1]/a").click()
  sleep(1)
  driver.find_element(xpath: "/html/body/bx-site/ng-component/div/sp-main/div/sp-nav/sp-nav-primary/nav/ul/li[10]/li").click()
  sleep(1)
  driver.find_element(xpath: "/html/body/bx-site/ng-component/div/sp-main/div/sp-nav/sp-nav-primary/nav/ul/li[5]/sp-nav-link/a").click()
  sleep(1)

  until driver.find_elements(id: 'showMore').count < 1
    driver.find_element(id: 'showMore').click
    sleep(1)
  end


  doc = Nokogiri::HTML(driver.page_source)
  coupons = doc.css('sp-coupon')

  coupons.each do |coupon|
    teams = coupon.css('.competitor-name')
    away_team = teams[0].text
    home_team = teams[1].text
    market_types = coupon.css('.market-type')
    
    spread = market_types[0]
    away_spread = spread.css('.bet-handicap')[0].text
    away_spread_cost = spread.css('.bet-price')[0].text
    home_spread = spread.css('.bet-handicap')[1].text
    home_spread_cost = spread.css('.bet-price')[1].text

    money_line = market_types[1]
    over_under = market_types[2]

    printer = "#{away_team} (#{away_spread}, #{away_spread_cost}) @ #{home_team} (#{home_spread}, #{home_spread_cost})"

    printer.gsub!(/[[:space:]]+/, "")

    puts printer

    File.open('./football-lines.txt', 'w+') do |file|
      file.puts printer
      file.puts "\n"
    end
  end

  driver.quit

end 


############### NFL Game Lines ###############
def get_politics_lines
  driver = Selenium::WebDriver.for :firefox
  driver.manage.window.minimize
  
  driver.navigate.to "https://www.bovada.lv"
  driver.find_element(xpath: "/html/body/bx-site/ng-component/bx-header-ch/div/nav/ul/li[1]/a").click()
  sleep(1)
  driver.find_element(xpath: "/html/body/bx-site/ng-component/div/sp-main/div/sp-nav/sp-nav-primary/nav/ul/li[10]/li").click()
  sleep(1)
  driver.find_element(:link, 'Politics').click()
  sleep(1)


  until driver.find_elements(id: 'showMore').count < 1
    driver.find_element(id: 'showMore').click
    sleep(1)
  end

  doc = Nokogiri::HTML(driver.page_source)
  coupons = doc.css('sp-coupon')
  email = ""

  coupons.each do |coupon|
    market_name = coupon.css('.market-name').text.gsub!(/[[:space:]]+/, "")
    outcomes = coupon.css('.outcomes')
    prices = coupon.css('.bet-price')
    email += "<strong> #{market_name} </strong>"
    email += "<br>"
    outcomes.each_with_index do |outcome, i|
      print = "#{outcome.text}, #{prices[i].text}"
      print.gsub!(/[[:space:]]+/, "")
      email += print
      email += "<br>"
    end 
    email += "<br>"
  end

  send_email('brock.m.tillotson@gmail.com', email)
  
  puts email
  driver.quit
end




