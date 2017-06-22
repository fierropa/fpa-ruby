class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.string :name
      t.string :description
      t.references :comparison, foreign_key: true
      t.timestamps
    end
  end
end
