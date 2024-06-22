class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def up
    create_table :subscriptions do |t|
      t.string :name
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end

  def down
    drop_table :subscriptions
  end
end
