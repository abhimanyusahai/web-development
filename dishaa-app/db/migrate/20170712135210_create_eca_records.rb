class CreateEcaRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :eca_records do |t|
      t.references :student, foreign_key: true
      t.text :eca_record
      t.string :doc_link
      t.text :doc_desc

      t.timestamps
    end
  end
end
