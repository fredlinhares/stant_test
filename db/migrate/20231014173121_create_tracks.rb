class CreateTracks < ActiveRecord::Migration[7.1]
  def change
    create_table :tracks do |t|

      t.timestamps
    end

    add_reference(:presentations, :track, index: true, foreign_key: true,
                  null: true)
    add_reference(
      :presentations, :previous_presentation,
      foreign_key: { to_table: :presentations },
      index: true,
      null: true)
    add_column :presentations, :morning, :bool, default: nil
  end
end
