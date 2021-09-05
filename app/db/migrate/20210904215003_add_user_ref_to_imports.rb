# frozen_string_literal: true

class AddUserRefToImports < ActiveRecord::Migration[6.1]
  def change
    add_reference :imports, :user, null: false, foreign_key: true
  end
end
