class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true, null: false
      t.references :resource, polymorphic: true, null: false

      t.index(%i[user_id resource_type resource_id], unique: true, name: 'index_subscriptions_on_user_id_and_res_type_and_res_id')

      t.timestamps
    end
  end
end
