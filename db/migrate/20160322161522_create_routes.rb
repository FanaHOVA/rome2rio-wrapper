class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :origin
      t.string :destination

      t.timestamps null: false
    end
  end
end
