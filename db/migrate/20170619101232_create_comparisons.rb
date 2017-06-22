class CreateComparisons < ActiveRecord::Migration[5.1]
  def change
    create_table :comparisons do |t|
      t.string :description

      t.timestamps
    end
  end
end
