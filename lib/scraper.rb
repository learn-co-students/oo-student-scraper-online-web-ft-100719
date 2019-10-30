require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css("div.student-card").each do |student|
      student_hash = {}
      student_hash[:name] = student.css("h4.student-name").text
      student_hash[:location] = student.css("p.student-location").text
      student_hash[:profile_url] = student.css("a").attribute("href").text
      students << student_hash
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student_profile = {}

    doc.css("div.main-wrapper.profile .social-icon-container a").each do |page| 
      if page.attribute("href").value.include?("twitter")
        student_profile[:twitter] = page.attribute("href").value
      elsif page.attribute("href").value.include?("linkedin")
        student_profile[:linkedin] = page.attribute("href").value
      elsif page.attribute("href").value.include?("github")
        student_profile[:github] = page.attribute("href").value
      else
        student_profile[:blog] = page.attribute("href").value
      end
    end
    student_profile[:profile_quote] = doc.css("div.main-wrapper.profile .vitals-text-container .profile-quote").text
    student_profile[:bio] = doc.css("div.main-wrapper.profile .description-holder p").text
    student_profile
  end

end


