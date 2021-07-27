class CreateLinkVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :link_visits do |t|
      t.references :shortened_link
      t.string :ip, null: false

      t.timestamps
    end
  end
end
