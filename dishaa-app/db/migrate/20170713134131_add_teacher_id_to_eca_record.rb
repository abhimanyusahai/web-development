class AddTeacherIdToEcaRecord < ActiveRecord::Migration[5.0]
  def change
    add_reference :eca_records, :teacher, foreign_key: true
  end
end
