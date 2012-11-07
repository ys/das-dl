require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'tempfile'
require 'optparse'
require 'highline/import'

email =  ask("Email:")
password = ask("Password:") { |q| q.echo = false }

# Create a new mechanize object
agent = Mechanize.new
#
# # Load the postmarkapp website
page = agent.get("https://www.destroyallsoftware.com/screencasts/users/sign_in")
#
# # Select the first form
form = agent.page.forms.first
form.field_with(name: "user[email]").value = email
form.field_with(name: "user[password]").value = password
#
# # Submit the form
page = form.submit form.buttons.first
temp_file = Tempfile.new('random')
cookie = ''
doc = Nokogiri::HTML(open("https://www.destroyallsoftware.com/screencasts/catalog", "Cookie" => cookie))
`mkdir -p #{ENV['HOME']}/Movies/screencasts/DAS/`
doc.css('a[href$="ios"]').map{ |a| a['href'] }.uniq.each do |link|
  link = "http://www.destroyallsoftware.com#{link}"
  puts link
  agent.pluggable_parser.default = Mechanize::Download
  puts "Downloading : #{link}"
  file_name = /(.*)\/(.*)\/download_ios/.match(link)[2]
  puts agent.get(link).save("#{ENV['HOME']}/Movies/screencasts/DAS/#{file_name}.mp4")
end
