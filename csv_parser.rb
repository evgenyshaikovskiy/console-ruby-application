require 'csv'

# parses csv to hash like
class CSVParser
  def parse_file(filepath)
    parsed_data = []
    CSV.foreach(filepath, headers: true) do |row|
      parsed_data.push(row.to_hash)
    end
    parsed_data
  end
end
