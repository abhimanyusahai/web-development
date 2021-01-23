class UploadGradeData < ActiveRecord::Migration[5.0]
  def change
    require 'csv'    

    CSV.foreach('tmp/grades.csv', headers: true, encoding: "ISO8859-1") do |row|
      Grade.create!(row.to_hash)
    end
  end
end
