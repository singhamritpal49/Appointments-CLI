class Client < ActiveRecord::Base

    has_many :appointments
    has_many :accountants, through: :appointments

end