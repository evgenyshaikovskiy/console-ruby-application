require 'readline'

# Class that defines application
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
      'exit' => method(:exit)
    }

    @is_running = true
  end

  def launch
    puts 'Ruby CLI application to work with PostgreSQL batabase.'
    puts 'Print your command or print help command to list available commands.'

    while @is_running
      input = Readline.readline('> ', true)
      command_input = input.split(' ')
      command = command_input.first

      parameters = command_input.length == 2 ? command_input.last : ''

      # refactor that part
      @commands[command].call(parameters)
    end
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
end

app = Application.new
app.launch
