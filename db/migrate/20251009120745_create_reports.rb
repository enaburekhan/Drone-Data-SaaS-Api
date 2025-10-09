class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports do |t|
      t.references :project, null: false, foreign_key: true
      t.string :title, null: false
      t.text :summary
      t.jsonb :insights, default: {}

      t.timestamps
    end
  end
end
