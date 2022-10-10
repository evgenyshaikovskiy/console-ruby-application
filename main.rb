require_relative 'application'
require_relative 'database'
require_relative 'csv_parser'

csv_parser = CSVParser.new
db_manager = DatabaseManager.new('usersdb', 'yauheni', 'password123', csv_parser)
application = Application.new(db_manager)

application.launch
