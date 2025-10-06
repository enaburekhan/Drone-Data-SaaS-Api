class CreateProcessedResults < ActiveRecord::Migration[8.0]
  def change
    create_table :processed_results do |t|
      t.references :upload, null: false, foreign_key: true
      t.string :result_type, null: false, default: "NDVI"
      t.string :data_url, null: false
      t.jsonb :metadata, default: {}

      t.timestamps
    end
    add_index :processed_results, :result_type
  end
end
