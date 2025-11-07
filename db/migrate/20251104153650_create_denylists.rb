class CreateDenylists < ActiveRecord::Migration[8.0]
  def change
    create_table :denylists do |t|
      t.string :jti, null: false
      t.datetime :exp, null: false

      t.timestamps
    end
    add_index :denylists, :jti
  end
end
