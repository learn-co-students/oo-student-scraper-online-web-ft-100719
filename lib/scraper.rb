require 'open-uri'
require 'pry'
require 'nokogiri'


class Scraper

  def self.scrape_index_page(index_url)
    
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    
    
    x = doc.css(".roster-cards-container").css(".student-card")
    binding.pry
    #doc.css(".roster-cards-container").css(".student-card").each do |student|
    #doc.css(".roster-cards-container").each |each_student_card|
      student_card.css("div").attributes("id").text
      #student = Student.new
      #  student.profile_page = 
      
      profile_page = student.css("a href").text
      student_name = student.css("h4 student-name").text
    #   binding.pry 
    # end
    
  end

  def self.scrape_profile_page(profile_url)
    
  end

end




