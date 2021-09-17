require 'roo'
# DOSE NOT ACCOUNT FOR DEVISE VAILDATION, WILL TELL YOU SAVED EVEN WITHOUT IT GOING TO THE DATABASE
namespace :import do
  desc "Import data from spreadsheet"
  task data: :environment do
    puts 'Importing Data'
    data = Roo::Spreadsheet.open('lib/data.xlsx') # open spreadsheet
    headers = data.row(1) # get header row
    data.each_with_index do |row, idx|
      next if idx == 0 # skip header row
      # create hash from headers and cells
      member_data = Hash[[headers, row].transpose]
      # next if user exists
      if Member.exists?(first_name: member_data['first_name'])
        puts "User with first_name #{member_data['first_name']} already exists"
        next
      end
      
      member = Member.new(member_data)
      puts "Saving User with first_name '#{member.first_name}'"
      # byebug
      member.save
    end
  end
end