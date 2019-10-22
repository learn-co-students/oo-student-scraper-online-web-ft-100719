require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index = open(index_url)
    html = Nokogiri::HTML(index)
    student_cards = html.css(".student-card")
    students = []
    student_cards.each do |student|
      new_student = {}
      new_student[:name] = student.css("h4").text
      new_student[:location] = student.css("p").text
      new_student[:profile_url] = student.css("a")[0]["href"]
      students << new_student
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile = open(profile_url)
    html = Nokogiri::HTML(profile)
    profile_page = {}
    social_medias = html.css(".social-icon-container").css("a")
    social_medias.each do |social|
      link = social["href"]
      link_parts = link.split(".com")
      website_name =  link_parts[0].gsub!(/https:\/\/(www.)?/, "")
      if website_name == "linkedin" || website_name == "github" || website_name == "twitter"
        profile_page[website_name.to_sym] = link
      else
        profile_page[:blog] = link
      end
    end
    profile_page[:profile_quote] = html.css(".profile-quote").text
    profile_page[:bio] = html.css(".description-holder").css("p").text
    profile_page
  end

end

