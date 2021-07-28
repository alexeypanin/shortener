class RemoveLinkIterations < ActiveRecord::Migration[6.0]
  def change
    remove_column :shortened_links, :ierations
  end
end
