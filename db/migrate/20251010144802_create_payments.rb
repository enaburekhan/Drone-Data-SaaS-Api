class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null:false
      t.string :status, null: false, default: "pending"
      t.string :provider, null: false
      t.string :transaction_id, null: false, index: { unique: true }
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end
