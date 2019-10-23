require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    all_students_arr = []
    doc = Nokogiri::HTML(open(index_url))
    student_info = doc.css("div.student-card")
    student_info.each do |info|
      student_hash = {}
      student_hash[:name] = info.css("h4").text.strip
      student_hash[:location] = info.css("p").text.strip
      student_hash[:profile_url] = info.css("a").attribute("href").value
      all_students_arr << student_hash
      student = Student.new(student_hash)
    end
    all_students_arr
    #binding.pry
  end

  def self.scrape_profile_page(profile_url)
    # :name DONE, :location DONE, :twitter, :linkedin, :github, :blog, :profile_quote DONE, :bio DONE, :profile_url DONE
    student_info = {}
    doc = Nokogiri::HTML(open(profile_url))
    vitals = doc.css(".vitals-container")
    vitals.each do |info|
      v_text = info.css(".vitals-text-container")
      social = info.css(".social-icon-container")
      #student_info[:name] = v_text.css(".profile-name").text.strip
      #student_info[:location] = v_text.css(".profile-location").text.strip
      student_info[:profile_quote] = v_text.css(".profile-quote").text.strip
      
      collection_of_socials = social.css("a").each {|a| a.attribute("href").value}
      
      i = 0
      collection_of_socials.each do |a_tag|
        if collection_of_socials[i].attribute("href").value.include?('twitter')
          student_info[:twitter] = collection_of_socials[i].attribute("href").value 
        elsif collection_of_socials[i].attribute("href").value.include?('linkedin')
          student_info[:linkedin] = collection_of_socials[i].attribute("href").value
        elsif collection_of_socials[i].attribute("href").value.include?('github')
        student_info[:github] = collection_of_socials[i].attribute("href").value 
        else 
          student_info[:blog] = collection_of_socials[i].attribute("href").value
        end
        i += 1
      end
    end
    details = doc.css(".details-container")
    details.each do |info|
      student_info[:bio] = info.css("div.bio-content.content-holder div.description-holder p").text.strip
    end

    student_info
    
  end

end

