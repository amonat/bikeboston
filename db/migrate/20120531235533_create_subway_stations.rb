class CreateSubwayStations < ActiveRecord::Migration
  def change
    create_table :subway_stations do |t|
      t.string :name
      t.string :lat
      t.string :lon

      t.timestamps
    end
  end
end
