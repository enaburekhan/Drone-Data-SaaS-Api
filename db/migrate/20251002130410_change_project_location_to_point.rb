class ChangeProjectLocationToPoint < ActiveRecord::Migration[8.0]
  def change
    remove_column :projects, :location
    add_column :projects, :location, :st_point, geographic: true
  end
end
