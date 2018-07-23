require 'selenium-webdriver'

driver = Selenium::WebDriver.for :firefox

driver.navigate.to "http://google.com"

if driver.title == 'Google'
  puts 'Test 1: Pass : Title Found'
else
  puts 'Test 1: Fail : Title Not Found'
end


driver.find_element(id: 'lst-ib').send_keys('math')


driver.find_element(:name, 'btnK').click()
