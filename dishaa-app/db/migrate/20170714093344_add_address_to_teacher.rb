class AddAddressToTeacher < ActiveRecord::Migration[5.0]
  def change
    add_column :teachers, :address, :string
  end
end
