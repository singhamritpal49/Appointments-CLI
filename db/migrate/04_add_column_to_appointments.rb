class AddColumnToAppointments < ActiveRecord::Migration[5.2]

def change 
    add_column :appointments, :clients, :string

end


end