class AddAddressComponents < ActiveRecord::Migration
  def up
  	add_column :locations, :city, :string
  	add_column :locations, :state, :string
  	 add_column :locations, :zip, :string
  end

  def down
  end
end
