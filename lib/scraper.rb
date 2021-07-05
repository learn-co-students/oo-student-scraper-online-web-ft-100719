require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = Nokogiri::HTML(open(index_url))
    student_array = []
    html.css(".student-card").each do |student|
      student_hash = {
        name: student.css("h4").text,
        location: student.css(".student-location").text,
        profile_url: student.css("a")[0]["href"]
      }
      student_array << student_hash
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    html = Nokogiri::HTML(open(profile_url))
    
    student_hash = {
      bio: html.css(".bio-block .description-holder").text.strip,
      profile_quote: html.css(".profile-quote").text.strip
    }

    html.css(".social-icon-container a").each do |link|
      url = link["href"]
      key = url.gsub("www.","").split(".")[0].split("/").last
      if key.include?("twitter") || key.include?("github") || key.include?("linkedin")
        student_hash[key.to_sym] = url
      else
        student_hash[:blog] = url
      end

    end

   
    student_hash
  end

end

