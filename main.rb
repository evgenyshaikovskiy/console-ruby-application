require_relative 'application'
require_relative 'database'

db_manager = DatabaseManager.new('usersdb', 'yauheni', 'password123')
application = Application.new(db_manager)

application.launch
