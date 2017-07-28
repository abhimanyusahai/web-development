class CreateExamTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :exam_types do |t|
      t.string :exam_type

      t.timestamps
    end
  end
end
