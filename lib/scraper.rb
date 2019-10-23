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
    # :name DONE, :location DONE, :twitter, :linkedin, :github, :blog, :profile_quote DONE, :bio DONE, :profile_url DONE
    student_hash = {:profile_url => profile_url}
    doc = Nokogiri::HTML(open(profile_url))
    vitals = doc.css(".vitals-container")
    vitals.each do |info|
      v_text = info.css(".vitals-text-container")
      social = info.css(".social-icon-container")
      student_hash[:name] = v_text.css(".profile-name").text.strip
      student_hash[:location] = v_text.css(".profile-location").text.strip
      student_hash[:profile_quote] = v_text.css(".profile-quote").text.strip
      social.each do |a_tags|
        binding.pry
      end
      student_hash[:twitter] = a_tags.css("a").attribute("href").value if a_tags.css("a").attribute("href").value.include?('twitter')
      student_hash[:linkedin] = a_tags.css("a").attribute("href").value if a_tags.css("a").attribute("href").value.include?('linkedin')
      student_hash[:github] = a_tags.css("a").attribute("href").value if a_tags.css("a").attribute("href").value.include?('github')
        #binding.pry
    end
    details = doc.css(".details-container")
    details.each do |info|
      student_hash[:bio] = info.css("div.bio-content.content-holder div.description-holder p").text.strip
    end
    
    student_hash
    
  end

end

