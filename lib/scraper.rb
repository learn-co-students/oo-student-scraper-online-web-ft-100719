require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    html = open(index_url)
    index_page = Nokogiri::HTML(html)
    
    index_page.css("div.student-card").each do |student|
      name = student.css("h4.student-name").text
      location = student.css("p.student-location").text
      profile_url = student.css("a").attribute("href").value
    
    student_info = 
    {
      :name =>name,
      :location => location,
      :profile_url => profile_url
    }
    
    students << student_info
    
    end
    students
  end

 def self.scrape_profile_page(profile_url)
    scraped_student = {}
    profile = Nokogiri::HTML(open(profile_url))

    profile.css(".social-icon-container a").each do |student|
      link = student.attribute("href").value
      if link.include?("twitter")
        scraped_student[:twitter] = link
      elsif link.include?("linkedin")
        scraped_student[:linkedin] = link
      elsif link.include?("github")
        scraped_student[:github] = link
      else
        scraped_student[:blog] = link
      end
    end

    scraped_student[:profile_quote] = profile.css("div.profile-quote").text
    scraped_student[:bio] = profile.css(".description-holder p").text

    scraped_student
  end
end
