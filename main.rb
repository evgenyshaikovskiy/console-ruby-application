require 'readline'
require 'pg'

# Singleton that defines application
class Application
  def initialize
    @help_messages = {
      'help' => 'help command prints the help screen.',
      'exit' => 'exit command exits the application.',
      'stats' => 'stats command prints number of users in usersdb.',
      'create' => 'command that create\'s new record in database using user\'s input.',
      'list' => 'list command shows all records in usersdb.',
      'edit' => 'edit command allows to edit record in usersdb.',
      'find' => 'find command allows to search record by given parameter.'
    }
    @commands = {
      'help' => method(:print_help),
      'exit' => method(:exit),
      'stats' => method(:stats)
    }

    @is_running = true
  end

  def launch
    puts 'Ruby CLI application to work with PostgreSQL batabase.'
    puts 'Print your command or print help command to list available commands.'
    puts 'Connecting to PostgreSQL database.'
    connect_to_db
    init_db
    while @is_running
      command, parameters = parse_command
      execute_command(command, parameters)
    end
  ensure
    @con&.close
  end

  private

  def parse_command
    input = Readline.readline('> ', true)
    command_input = input.split(' ', 2)
    command = command_input.first

    parameters = command_input.length == 2 ? command_input.last : ''

    [command, parameters]
  end

  def execute_command(command, parameters)
    if @commands.key?(command)
      @commands[command].call(parameters)
    else
      print_help(command)
    end
  end

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
end

app = Application.new
app.launch
