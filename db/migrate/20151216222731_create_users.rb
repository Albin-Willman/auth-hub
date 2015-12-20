class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :email
      t.string    :name
      t.string    :password_digest
      t.string    :token
      t.boolean   :active, default: false

      t.timestamps
    end
  end
end
