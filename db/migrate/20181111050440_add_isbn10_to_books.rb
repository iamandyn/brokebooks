class AddIsbn10ToBooks < ActiveRecord::Migration[5.2]
  def change
  	add_column :books, :isbn10, :string
  	rename_column :books, :isbn, :isbn13
  end
end
