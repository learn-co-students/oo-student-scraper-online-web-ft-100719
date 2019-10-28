require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_url = "https://learn-co-curriculum.github.io/student-scraper-test-page/index.html"
    html= open(index_url)
    doc= Nokogiri::HTML(html)
    scraped_students=[]
    student_cards=doc.css('div.student-card')
    student_cards.each do |student_card|
      student_hash= {
        name: student_card.css('h4.student-name').text,
        location: student_card.css('p.student-location').text,
        profile_url:  student_card.css('a').attribute("href").value
      }
      scraped_students << student_hash
      student= Student.new (student_hash)
      #  binding.pry
    end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    html=open(profile_url)
    doc= Nokogiri::HTML(html)
    # binding.pry
    student_card={}
    info=doc.css('div.social-icon-container').css('a')
    info.each do |x|
      if x.attribute("href").value.include?("twitter")
        student_card[:twitter]= x.attribute("href").value
      elsif x.attribute("href").value.include?("linkedin")
        student_card[:linkedin]= x.attribute("href").value
      elsif x.attribute("href").value.include?("github")
        student_card[:github]= x.attribute("href").value
      else 
        student_card[:blog]= x.attribute("href").value
      end
    end
      student_card[:profile_quote]=doc.css('div.vitals-text-container').css('div.profile-quote').text
      student_card[:bio]=doc.css('div.details-container').css('div.description-holder').css('p').text
      student_card

  end

end

