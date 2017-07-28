class RenameMenteeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :students, :teacher_id, :mentee_teacher_id
  end
end
