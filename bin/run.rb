require 'pry'
require_relative '../config/environment'
require 'tty-prompt'
system 'clear'



 class CommandLineInterface

    def initialize
        @prompt = TTY::Prompt.new
    end




    def new_client 
        client_name =  @prompt.ask("Please Enter Your Name")
        client_phone = @prompt.ask("Please Enter Your Phone Number")
        client_email = @prompt.ask("Please Enter Your Email Address")
        @client = Client.create(name: client_name, phone: client_phone, email: client_email)
    end

    def login
        @prompt.select "Are you a returning user?" do |menu|
            menu.choice "Yes", -> do
                phone = @prompt.ask("Please Enter Your Phone Number")
                @client = Client.find_by(phone: phone)


                if @client.nil?
                    puts "sorry, cannot find user with that phone"
                    @prompt.select "What would you like to do?" do |m|
                        m.choice "Try Again", -> { login }
                        m.choice "Create Account", -> { new_client } # create account for user }
                        m.choice "Exit"
                    end
                end
            end

            menu.choice "No, (Create New Account)", -> { new_client }
                
        
    
        end
    end


    def schedule_appointment 
        entered_time = @prompt.ask("Plase Enter Date and Time -> Ex. 12/12/12 AT 12:00 PM ")
        @client.appointments << Appointment.create(time: entered_time, accountant_id: 1)
    end



        
    def view_appointment
        if @client.appointments.length < 1
            puts "You currently have no appointments"
        else 
            puts "Here are your appointments:"
            @client.appointments.pluck(:time).each { |time| puts " - #{time}" } 
            @prompt.select "" do |m| 
                m.choice "back", -> { appointment_system }
            end
        end
    end


    def change_appt(appt)
        time = @prompt.ask("Please Enter the time")
        appt.update(time: time)
    end

    def reschedule_appointment
        @prompt.select "Which appointment would you like to Reschedule?" do |menu|
            @client.appointments.each do |appt|
                menu.choice appt.time, -> { change_appt(appt)  }
                
            end
        end
        @client.reload

        #appt.update(time:)

    end



    def cancel_appointment
        @prompt.select "Which appointment would you like to cancel?" do |menu|
            @client.appointments.each do |appt|
                menu.choice appt.time, -> { appt.destroy }
            end
        end
        @client.reload
        
        # Appointment.all.each do |appointment|
        #     puts appointment.time
        # end
    end


    def appointment_system
        puts `clear`
        puts "Welcome to Singh Accounting Online Appointment System"
        
        @prompt.select("Please Select Your Option") do |menu|
            menu.choice "Schedule Appointment", -> { schedule_appointment } 
            menu.choice "View Appointment", -> { view_appointment }
            menu.choice "Reschedule Appointment", -> { reschedule_appointment }
            menu.choice "Cancel Appointment", -> { cancel_appointment }
            menu.choice "Exit"
        end
            
    end

end

cli = CommandLineInterface.new

cli.login
cli.appointment_system

#cli.cancel_appointment




















# cli.view_appointment
#cli.reschedule_appointment
