class CreateSubwayStops < ActiveRecord::Migration
  def change
    create_table :subway_stops do |t|
      t.string :code
      t.belongs_to :subway_station
      t.references :subway_line

      t.timestamps
    end
  end
end
