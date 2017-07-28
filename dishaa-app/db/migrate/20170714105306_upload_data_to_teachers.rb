class UploadDataToTeachers < ActiveRecord::Migration[5.0]
  def change
    require 'csv'    

    CSV.foreach('tmp/teachers_db.csv', headers: true, encoding: "ISO8859-1") do |row|
      Teacher.create!(row.to_hash)
    end
  end
end
