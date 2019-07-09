class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.string :time
      t.integer :accountant_id
      t.integer :client_id
    end
  end
end
