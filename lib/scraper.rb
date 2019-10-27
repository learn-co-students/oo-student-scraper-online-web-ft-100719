require 'nokogiri'
require 'open-uri'
require 'pry'

require_relative './student.rb'

class Scraper

  def self.scrape_index_page(index_url)
    doc= Nokogiri::HTML(open(index_url))
    all_students=[]
    doc.css(".student-card a").each do |student|
        name=student.css("h4").text
        location= student.css("p").text
        profile_url="#{student.attr('href')}"
        student_hash={name:name, location:location, profile_url:profile_url}
        all_students << student_hash
      end
      all_students
    end

  def self.scrape_profile_page(profile_url)
    page=Nokogiri::HTML(open(profile_url))
    student_attr={}
    page.css(".social-icon-container").xpath('//div/a/@href').each do |social|
      if social.value.include?("twitter")
        student_attr[:twitter]=social.value
      elsif social.value.include?("linkedin")
        student_attr[:linkedin]=social.value
      elsif social.value.include?("github")
        student_attr[:github]=social.value
      else
        student_attr[:blog]=social.value
      end
    end
    student_attr[:profile_quote]= page.css(".profile-quote").text
    student_attr[:bio]=page.css("p").text
    student_attr
  end


end
