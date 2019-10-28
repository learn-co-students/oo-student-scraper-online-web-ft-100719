#require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    scraped_students = Array.new
    doc = Nokogiri::HTML(open(index_url))
    doc.css("div.student-card").each do |student|
      student_hash = {
        name: student.css("a div.card-text-container h4.student-name").text,
        location: student.css("a div.card-text-container p.student-location").text,
        profile_url: student.css("a").attribute("href").value
      }
      scraped_students << student_hash
    end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    doc  = Nokogiri::HTML(open(profile_url))
    scraped_student = {
      bio: doc.css("div.description-holder p").text,
      profile_quote: doc.css("div.profile-quote").text,
    }
    social_links = doc.css("div.social-icon-container a")
    social_links.each do |link|
      if link.attribute("href").value.include?("twitter")
        scraped_student[:twitter] = link.attribute("href").value
      elsif link.attribute("href").value.include?("linkedin")
        scraped_student[:linkedin] = link.attribute("href").value
      elsif link.attribute("href").value.include?("github")
        scraped_student[:github] = link.attribute("href").value
      else 
        scraped_student[:blog] = link.attribute("href").value
      end  
    end
    scraped_student
  end

end

