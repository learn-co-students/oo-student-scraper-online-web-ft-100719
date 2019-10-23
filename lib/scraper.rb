require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    all_students_arr = []
    doc = Nokogiri::HTML(open(index_url))
    student_info = doc.css("div.student-card")
    student_info.each do |info|
      student = Student.new(student_hash)
      student_hash = {}
      student_hash[:name] = info.css("h4").text.strip
      student_hash[:location] = info.css("p").text.strip
      student_hash[:profile_url] = info.css("a").attribute("href").value
      all_students_arr << student_hash
    end
    all_students_arr
    #binding.pry
  end

  def self.scrape_profile_page(profile_url)
    # :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url
    student = {}
    doc = Nokogiri::HTML(open(index_url))
    
  end

end

