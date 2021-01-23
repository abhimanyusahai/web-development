class CreateMarks < ActiveRecord::Migration[5.0]
  def change
    create_table :marks do |t|
      t.references :student, foreign_key: true
      t.references :subject, foreign_key: true
      t.references :exam_type, foreign_key: true
      t.date :date
      t.float :marks_achieved
      t.float :max_marks

      t.timestamps
    end
  end
end
