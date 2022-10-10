require 'pg'

require_relative 'validation'
require_relative 'utils'

# Singleton that defines application
class Application
  def initialize
    @help_messages = ApplicationUtility.help_messages
    @commands = {
      'help' => method(:print_help), 'exit' => method(:exit),
      'stats' => method(:stats), 'create' => method(:create),
      'list' => method(:list), 'edit' => method(:edit),
      'find' => method(:find), 'delete' => method(:delete)
    }
    @is_running = true
  end

  def launch
    ApplicationUtility.print_welcome_message
    connect_to_db
    init_db
    while @is_running
      command, parameters = ApplicationUtility.parse_command
      execute_command(command, parameters)
    end
  ensure
    @con&.close
  end

  # private methods
  private

  def stats(_parameters)
    result = @con.exec 'SELECT COUNT(*) FROM users;'
    puts "Count of users is #{result.getvalue(0, 0)}."
  rescue PG::Error => e
    puts e.message
  end

  def print_help(parameters)
    if @help_messages.key?(parameters)
      puts @help_messages[parameters]
    else
      puts 'List of available commands: '
      @help_messages.each { |key, value| puts "#{key} \t-\t #{value}" }
    end
  end

  # underscore near argument tells it won't be used
  def exit(_parameters)
    @is_running = false
    puts 'Closing the application...'
  end

  def connect_to_db
    @con = PG.connect dbname: 'usersdb', user: 'yauheni', password: 'password123'
  rescue PG::Error => e
    puts e.message
  end

  def init_db
    @con.exec 'CREATE TABLE IF NOT EXISTS
    users(id SERIAL PRIMARY KEY, first_name VARCHAR(20), last_name VARCHAR(20), balance INTEGER);'
  rescue PG::Error => e
    puts e.message
    exit
  end

  def create(_parameters)
    first_name, last_name, balance = ApplicationUtility.read_input

    if Validation.valid_user?(first_name, last_name, balance)
      @con.exec "INSERT INTO users(first_name, last_name, balance) VALUES('#{first_name}', '#{last_name}', #{balance});"
      puts 'User successfully added.'
    else
      puts 'Invalid input. Try again.'
    end
  rescue PG::Error => e
    puts e.message
  end

  def list(_parameters)
    result = @con.exec 'SELECT * FROM users;'
    ApplicationUtility.form_output(result)
  rescue PG::Error => e
    puts e.message
  end

  def edit(parameters)
    where_clause = ApplicationUtility.form_where_clause(parameters)
    puts 'Found following records: '
    find(parameters)
    puts 'Set up properties for those records: '
    editted = gets.chomp.to_s
    set_clause = ApplicationUtility.form_set_clause(editted)
    @con.exec "UPDATE users #{set_clause} #{where_clause};"
  rescue PG::Error => e
    puts e.message
  end

  def find(parameters)
    where_clause = ApplicationUtility.form_where_clause(parameters)
    result = @con.exec "SELECT * FROM users #{where_clause};"
    ApplicationUtility.form_output(result)
  rescue PG::Error => e
    puts e.message
  end

  def delete(parameters)
    where_clause = ApplicationUtility.form_where_clause(parameters)
    @con.exec "DELETE FROM users #{where_clause}"
  rescue PG::Error => e
    puts e.message
  end

  def execute_command(command, parameters)
    if @commands.key?(command)
      @commands[command].call(parameters)
    else
      print_help(command)
    end
  end
end

app = Application.new
app.launch
