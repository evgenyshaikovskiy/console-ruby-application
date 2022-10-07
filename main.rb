require 'readline'

# Class that defines application
class Application
  def initialize
    @help_messages = {
      'help' => 'prints the help screen.',
      'exit' => 'exits the application.',
      'stats' => 'prints number of users in usersdb.',
      'create' => 'create\'s new record in database using user\'s input.',
      'list' => 'shows all records in usersdb.',
      'edit' => 'allows to edit record in usersdb.',
      'find' => 'allows to search record by given parameter.'
    }
  end

  def launch
    puts 'Ruby CLI application to work with PostgreSQL batabase.'
    puts 'Print your command or print help command to list available commands.'

    while (input = Readline.readline('> ', true))
      command_input = input.split(' ', 2)
      command = command_input.first
      parameters = command_input.last

    end
  end

  def print_help_message(parameters)
  end
end

app = Application.new
app.launch
