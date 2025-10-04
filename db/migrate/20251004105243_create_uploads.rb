class CreateUploads < ActiveRecord::Migration[8.0]
  def change
    create_table :uploads do |t|
      t.references :project, null: false, foreign_key: true
      t.string :status, default: "pending"
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end
