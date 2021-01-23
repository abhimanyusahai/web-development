class AddMenteeToStudent < ActiveRecord::Migration[5.0]
  def change
    add_reference :students, :teacher, foreign_key: true
  end
end
