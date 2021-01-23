class CreateGradeSubjects < ActiveRecord::Migration[5.0]
  def change
    create_table :grade_subjects do |t|
      t.references :grade, foreign_key: true
      t.references :subject, foreign_key: true
      t.references :teacher, foreign_key: true

      t.timestamps
    end
  end
end
