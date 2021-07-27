class CreateShortenedLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :shortened_links do |t|
      t.string :original_url
      t.string :shortened_url
      t.integer :transitions, default: 0

      t.timestamps
    end

    add_index :shortened_links, :shortened_url
  end
end
