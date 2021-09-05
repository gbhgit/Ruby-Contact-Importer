# frozen_string_literal: true

class CreateImports < ActiveRecord::Migration[6.1]
  def change
    create_table :imports do |t|
      t.text :status

      t.timestamps
    end
  end
end
