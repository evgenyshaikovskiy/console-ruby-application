require 'readline'

# static module that provides utility for application
module ApplicationUtility
  def self.parse_command
    input = Readline.readline('> ', true)
    command_input = input.split(' ', 2)
    command = command_input.first

    parameters = command_input.length == 2 ? command_input.last : ''

    [command, parameters]
  end

  def self.print_welcome_message
    puts 'Ruby CLI application to work with PostgreSQL batabase.'
    puts 'Print your command or print help command to list available commands.'
    puts 'Connecting to PostgreSQL database.'
  end

  def self.help_messages
    { 'help' => 'help command prints the help screen.', 'exit' => 'exit command exits the application.',
      'print-user-info' => 'command prints all available user information.',
      'print-icons-info' => 'command prints information on user and his icons.',
      'print-pics-info' => 'command prints information on user and his library pictures.' }
  end
end