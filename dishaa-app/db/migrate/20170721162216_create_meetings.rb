class CreateMeetings < ActiveRecord::Migration[5.0]
  def change
    create_table :meetings do |t|
      t.date :date
      t.string :time
      t.string :venue
      t.text :agenda

      t.timestamps
    end
  end
end
