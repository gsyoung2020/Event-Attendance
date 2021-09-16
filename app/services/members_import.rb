class MembersImport
    require 'roo'
  
    attr_accessor :file
  
    def initialize(attributes={})
      attributes.each { |name, value| send("#{name}=", value) }
    end
  
    def persisted?
      false
    end
  
    def open_spreadsheet
      case File.extname(file.original_filename)
      when ".csv" then Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise "Unknown file type: #{file.original_filename}"
      end
    end
  
    def load_imported_members
      spreadsheet = open_spreadsheet
      header = spreadsheet.row(5)
      (6..spreadsheet.last_row).map do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        member = Member.find_by_id(row["id"]) || Member.new
        member.attributes = row.to_hash
        member
      end
    end
  
    def imported_members
      @imported_members ||= load_imported_members
    end
  
    def save
      if imported_members.map(&:valid?).all?
        imported_members.each(&:save!)
        true
      else
        imported_members.each_with_index do |member, index|
            member.errors.full_messages.each do |msg|
            errors.add :base, "Row #{index + 6}: #{msg}"
          end
        end
        false
      end
    end
end


