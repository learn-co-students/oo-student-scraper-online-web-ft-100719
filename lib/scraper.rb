require 'open-uri'
require 'pry'
require 'nokogiri'


class Scraper

  @@student_array = []
  def self.scrape_index_page(index_url)
    
    
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    
    doc.css(".roster-cards-container > .student-card").each do |each_student| 
      student_summary = {}
      student_summary[:name] = each_student.css(".student-name").text
      student_summary[:location] = each_student.css(".student-location").text
      student_summary[:profile_url] = each_student.css("a").attribute("href").value
      @@student_array << student_summary
    end #each
    @@student_array
  end #scrape_index_page

  def self.scrape_profile_page(profile_url)
    @@student_profile_hash = {}
    html = open(profile_url)
    
    doc = Nokogiri::HTML(html)
    
   
    doc.css(".social-icon-container > a").each do |socmed| 
      url = socmed.attribute("href").value
      if url.include?("linkedin")
        @@student_profile_hash[:linkedin] = url
      elsif url.include?("twitter")
        @@student_profile_hash[:twitter] = url
      elsif url.include?("github")
        @@student_profile_hash[:github] = url
      elsif url.include?("http:")
        @@student_profile_hash[:blog] = url
      end
      
    end 
    @@student_profile_hash[:quote] = doc.css(".vitals-text-container > .profile-quote").text
    @@student_profile_hash[:bio] = doc.css(".bio-content.content-holder > .description-holder > p").text
   #binding.pry
   @@student_profile_hash
  end
end




