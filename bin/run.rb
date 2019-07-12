require 'pry'
require_relative '../config/environment'
require 'tty-prompt'
system 'clear'



 class CommandLineInterface

    def initialize
        @prompt = TTY::Prompt.new
    end


    #this is to add new client if he do not exist in the db
    def new_client 
        client_name =  @prompt.ask("Please Enter Your Name")
        client_phone = @prompt.ask("Please Enter Your Phone Number")
        client_email = @prompt.ask("Please Enter Your Email Address")
        @client = Client.create(name: client_name, phone: client_phone, email: client_email)
        appointment_system 
    end


    #This is login method is displayed first
    def login
        puts "Welcome to Singh Accounting Online Appointment System"
        @prompt.select "Are you a returning client?" do |menu|
            menu.choice "Yes", -> do
                phone = @prompt.ask("Please Enter Your Phone Number")
                @client = Client.find_by(phone: phone)
                
            

                if @client.nil?
                    puts "Sorry, cannot find client with that phone"
                    @prompt.select "What would you like to do?" do |m|
                        m.choice "Try Again", -> { login }
                        m.choice "Create Account", -> { new_client }
                        m.choice "Exit", -> {  exit_method  }
                    end
                end
            end

            menu.choice "No (Create New Client Portal)", -> { new_client }
            menu.choice "Exit The System", -> { exit_method }
            
        
    
        end
    end


    #this is helper method
    def ask
        @prompt.select "Would you like to schedule appointment now" do |menu|
            menu.choice " Yes", ->  { schedule_appointment }
            menu.choice " No <Go Back>", ->  { appointment_system }
        end
    end

    # since we already know who the client is we can simply push the appointment to @client (joiner Instance)
    def schedule_appointment 
        entered_time = @prompt.ask("Plase Enter Date and Time -> Ex. 12/12/12 AT 12:00 PM ")
        @client.appointments << Appointment.create(time: entered_time,clients: @client.name) 
        accountant_all
            appointment_system
            #accountant_id: Accountant.first.id, 
    end



        #This method is checking the appointments array if the client has appointments it will display
    def view_appointment
        if @client.appointments.length < 1
            puts "You currently have no appointments"
            sleep(2)
        else 
            puts "Here are your appointments:"
            @client.appointments.pluck(:time).each { |time| puts " - #{time}" } 
            @prompt.select "" do |m| 
                m.choice "<Go Back>", -> { appointment_system }
            end
        end
            appointment_system
    end

    #this is a helper method for changing appointments
    def change_appt(appt) 
        time = @prompt.ask("Plase Enter The New Date and Time -> Ex. 12/12/12 AT 12:00 PM")
            appt.update(time: time)
    end

    #this method is for re
    def reschedule_appointment
        if @client.appointments.length < 1
            puts "You currently have no appointments"
            sleep(2)
        else
        @prompt.select "Which appointment would you like to Reschedule?" do |menu|
            @client.appointments.each do |appt|
                menu.choice appt.time, -> { change_appt(appt)  }
            end
                menu.choice "<Go Back>", -> {  appointment_system   }  #back 
            end
        end
              @client.reload

            appointment_system
    end


    #This method is for canceling the appointment using .destory
    def cancel_appointment
        if @client.appointments.length < 1
            puts "You currently have no appointments"
           sleep(2)
        else
        @prompt.select "Which appointment would you like to cancel?" do |menu|
            @client.appointments.each do |appt|
                menu.choice appt.time, -> { appt.destroy }  
            end
            menu.choice "<Go Back>", -> {  appointment_system    } #back
        end
    end
        @client.reload
        appointment_system
    end


    def exit_method
        exit
    end


    def appointment_system
        puts `clear`
        @prompt.select("Please Select Your Option") do |menu|
            menu.choice "Schedule Appointment", -> { ask } 
            menu.choice "View Appointment", -> { view_appointment }
            menu.choice "Reschedule Appointment", -> { reschedule_appointment }
            menu.choice "Cancel Appointment", -> { cancel_appointment }
            menu.choice "Exit", -> { exit_method }
        end
            
    end


    #   def admin_view
    #       Appointment.all.each do |appt|
    #           puts "Name: #{appt.clients} Time:  #{appt.time}"
    #   end
    #  end

    def accountant_all
        @prompt.select("Select Accountant") do |menu|

        Accountant.all.each do |accountant|
            #binding.pry
            menu.choice "#{accountant.name}", -> { @client.appointments.last.update(accountant_id: accountant.id) }
                                                    # appointment
            end
            #menu.choice "<Go Back>", -> { exit_method }
        end
    end

    #@client.appointments << Appointment.create(accountant_id: )

    # def select_accountant
    #     @client.accountant



    # end



    
end

cli = CommandLineInterface.new

cli.login
cli.appointment_system

#cli.accountant_all
