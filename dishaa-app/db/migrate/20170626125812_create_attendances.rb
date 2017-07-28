class CreateAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :attendances do |t|
      t.references :student, foreign_key: true
      t.references :grade, foreign_key: true
      t.references :subject, foreign_key: true
      t.date :date
      t.boolean :present
      t.boolean :absent
      t.boolean :on_leave

      t.timestamps
    end
  end
end
