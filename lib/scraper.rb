require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = URI.open(index_url)
    doc = Nokogiri::HTML(html)

    students = doc.css(".student-card")
    student_names = students.css(".student-name").map(&:text)
    student_locations = students.css(".student-location").map(&:text)
    student_profile_urls = students.css("a").map { |element| element.attribute("href").value }

    student_array = student_names.map.with_index do |student_name, index|
      {
        name: student_name,
        location: student_locations[index],
        profile_url: student_profile_urls[index]
      }
    end
    student_array
  end

  def self.social_urls_from_profile(doc)
    doc.css(".social-icon-container a").map { |link| link.attribute("href").value }
  end

  def self.profile_builder(doc, social_media_urls)
    profile_array = []
    
    profile_array << social_media_urls.find { |url| url.include?('twitter') }
    profile_array << social_media_urls.find { |url| url.include?('linkedin') }
    profile_array <<   social_media_urls.find { |url| url.include?('github') }
    profile_array <<   social_media_urls.find do |url|
      %w[facebook youtube twitter linkedin github].none? { |social| url.include? social }
    end
    profile_array << doc.css(".vitals-text-container .profile-quote").text
    profile_array << doc.css(".description-holder p").text
    profile_array
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(URI.open(profile_url))

    profile_data_array = profile_builder(doc, social_urls_from_profile(doc))

    profile_data = {}

    %i[twitter linkedin github blog profile_quote bio].each_with_index do |piece_of_info, index|
      profile_data[piece_of_info] = profile_data_array[index] if profile_data_array[index]
    end

    profile_data
  end
end