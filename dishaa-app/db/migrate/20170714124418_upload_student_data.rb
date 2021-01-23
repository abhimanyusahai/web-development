class UploadStudentData < ActiveRecord::Migration[5.0]
  def change
    require 'csv'    

    CSV.foreach('tmp/students.csv', headers: true, encoding: "ISO8859-1") do |row|
      Student.create!(row.to_hash)
    end
  end
end
