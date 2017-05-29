require 'selenium-webdriver'
def run
  url = ARGV[0]
  driver = Selenium::WebDriver.for :chrome
  driver.navigate.to(url)
  element = driver.find_element(:id, 'mp3flashPlayer')
  download_url =  element.attribute(:src)
  driver.quit
  puts download_url
end
run
