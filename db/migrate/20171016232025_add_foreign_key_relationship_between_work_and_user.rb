class AddForeignKeyRelationshipBetweenWorkAndUser < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :works, :users
  end
end
