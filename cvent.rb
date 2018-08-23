require 'selenium-webdriver'
require 'nokogiri'
require 'csv'
require 'pp'


######################################
########### driver setup #############
######################################
driver = Selenium::WebDriver.for :firefox


######################################
########### functions #############
######################################

def opus_login(params)
  driver = params[:driver]

  driver.navigate.to "https://app.cvent.com/subscribers/Login.aspx?ReturnUrl=%2fsubscribers%2fdefault.aspx"
  sleep(1)

  account = driver.find_element(id: "account")
  username = driver.find_element(id: "username")
  password = driver.find_element(id: "password")
  submit = driver.find_element(id: "btnLogin")
  sleep(1)
  account.send_keys("OEAOR001")
  username.send_keys(params[:username])
  password.send_keys(params[:password])
  submit.click()
end


def select_event(params)
  driver = params[:driver]
  wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  wait.until { driver.find_element(:link_text, params[:event_name]) }
  event = driver.find_element(:link_text, params[:event_name])
  event.click()
end


def find_registrant(params, attendee_info)
  driver = params[:driver]
  wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  registration_management = driver.find_element(:link_text, "Invitees & Registrants")
  registration_management.click()
  wait.until { driver.find_element(:id, "GridFilterTextBox-Attendees") }
  search_box = driver.find_element(:id, "GridFilterTextBox-Attendees")
  search_box.clear
  search_box.send_keys(attendee_info[:email])
  search_button = driver.find_element(:id, "GridFilterButton-Attendees")
  search_button.click()
  wait.until { driver.find_element(:link_text, "#{attendee_info[:last_name]}, #{attendee_info[:first_name]}") }
  person_link = driver.find_element(:link_text, "#{attendee_info[:last_name]}, #{attendee_info[:first_name]}")
  person_link.click()
end


def go_to_modify_reg(params)
  driver = params[:driver]
  wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  driver.execute_script("document.getElementsByClassName('cv-dropdown-menu-body')[3].classList.add('is-visible')")
  wait.until { driver.find_element(:id, 'ModifyRegistration') }
  driver.find_element(:id, 'ModifyRegistration').click()
  sleep(2)
  wait.until { driver.find_element(id: 'register') }
  driver.switch_to.frame(driver.find_element(id: 'register'))
  driver.find_element(:id, 'ctl00_ContentPlaceHolder1_ctl01_rptRegistrants_ctl00_btnModifyRegInfo').click()
end


############################
##### script to run ########
############################

params = {
          username: 'brock.tillotson@opusteam.com', 
          password: 'CVRock7900', 
          driver: driver, 
          event_name: 'ZZZ_Brocks_Cool_Event', 
        }

attendee_info = {
                 first_name: 'asdf', 
                 last_name: 'sdf', 
                 email: 'asdf@sdf.com'
                }


opus_login(params)
select_event(params)
find_registrant(params, attendee_info)
go_to_modify_reg(params)


