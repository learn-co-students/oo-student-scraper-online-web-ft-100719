class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  def initialize(student_hash)
    student_hash {|i, j| self.send(("#{i}"),j)}
  end

  def self.create_from_collection(students_array)
    students_array.each do |student_hash|
      self.new(student_hash)
  end

  def add_student_attributes(attributes_hash)
    attributes_hash.each do |i, j|
      self.send(("#{i}="), j)
    end
    self
  end

  def self.all
    @@all
  end
end

