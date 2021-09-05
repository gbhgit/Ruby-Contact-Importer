class CreateLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :logs do |t|
      t.text :error
      t.references :import, null: false, foreign_key: true

      t.timestamps
    end
  end
end
