class AddLatLonToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :latitude, :decimal, precision: 10, scale: 6
    add_column :projects, :longitude, :decimal, precision: 10, scale: 6
  end
end
