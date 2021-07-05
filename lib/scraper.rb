require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card a").each do |student| 
      # binding.pry
      student_hash = {}
    student_hash[:name] = student.css(".student-name").text.strip
    student_hash[:location] = student.css(".student-location").text.strip
    student_hash[:profile_url] = student.attr("href") 
      # binding.pry
    students << student_hash
        # binding.pry
    end
    students

  end

  def self.scrape_profile_page(profile_url)
    
      doc = Nokogiri::HTML(open(profile_url))
      # binding.pry
      card = doc.css("div.main-wrapper.profile")
      student = {}
      if card.css(".social-icon-container a").count > 0
        card.css(".social-icon-container a").each do  |social| 
        # binding.pry
          if social.attribute("href").value.include?("twitter") 
            student[:twitter] = social.attribute("href").value
          elsif social.attribute("href").value.include?("linkedin") 
            student[:linkedin] = social.attribute("href").value
          elsif social.attribute("href").value.include?("github") 
            student[:github] = social.attribute("href").value 
          elsif social.attribute("href").value.include?("http:") 
             student[:blog] = social.attribute("href").value
          end
        end
      end
      student[:profile_quote] = card.css(".profile-quote").text
      student[:bio] = card.css(".description-holder p").text
      # binding.pry 
      student
      # binding.pry
   end

end

