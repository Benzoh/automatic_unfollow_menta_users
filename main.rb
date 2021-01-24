require "bundler/setup"
require 'selenium-webdriver'
require 'yaml'

config = YAML.load_file("config.yml")

id = config["id"]
pass = config["pass"]
follows_page_url = config['follows_page_url']

driver = Selenium::WebDriver.for :chrome

driver.get follows_page_url

el = driver.find_element(:xpath, '//*[@id="vheader"]/header[1]/div/div[2]/div[2]/a')
el.click

sleep 2

input1 = driver.find_element(:xpath, '//*[@id="login"]/div[3]/div[2]/input')
input1.send_keys id

input2 = driver.find_element(:xpath, '//*[@id="login"]/div[4]/div[2]/input')
input2.send_keys pass
input2.send_keys(:enter)

sleep 2

driver.get follows_page_url

sleep 2

# FIXME: ページ下部までスクロールして読み込んでないので20件ごとになってる
elements = driver.find_elements(:class, 'user_box')

elements.length.times {
  user = driver.find_element(:xpath, '//*[@id="app"]/div/div[2]/div[1]/a')
  user.click

  unfollow = driver.find_element(:xpath, '//*[@id="app"]/div[2]/div/div[2]/div[1]/a[1]')
  unfollow.click

  sleep 2

  driver.get follows_page_url
}

sleep 5

driver.quit