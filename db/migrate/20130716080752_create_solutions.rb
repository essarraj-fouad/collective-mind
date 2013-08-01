class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.integer :user_id
      t.integer :question_id
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
