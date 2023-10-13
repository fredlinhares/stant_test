class CreatePresentations < ActiveRecord::Migration[7.1]
  def change
    create_table :presentations do |t|
      t.string :title, index: { unique: true }
      t.integer :duration_in_minutes
      t.boolean :is_lightning, default: false

      t.timestamps
    end
  end
end
