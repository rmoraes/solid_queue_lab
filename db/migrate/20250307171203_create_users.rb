class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.timestamps

      t.string :name,   null: false, limit: 100
      t.string :status, null: false, limit: 15, default: :active
      t.string :kind, null: false, limit: 15
    end
  end
end
