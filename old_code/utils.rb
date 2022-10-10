require 'readline'

# module that contains utility for application
module ApplicationUtility
  def self.help_messages
    { 'help' => 'help command prints the help screen.', 'exit' => 'exit command exits the application.',
      'stats' => 'stats command prints number of users in usersdb.',
      'create' => 'command that create`s new record in database using user`s input.',
      'list' => 'list command shows all records in usersdb.',
      'edit' => 'edit command allows to edit record in usersdb.
          Params: [<first-name>=value, <last-name>=value, <balance>=value].',
      'find' => 'find command allows to search record by given parameter.
          Params: [<first-name>=value, <last-name>=value, <balance>=value].',
      'delete' => 'command delete`s one or multiple users by given parameter.
          Params: [<first-name>=value, <last-name>=value, <balance>=value].' }
  end

  def self.print_welcome_message
    puts 'Ruby CLI application to work with PostgreSQL batabase.'
    puts 'Print your command or print help command to list available commands.'
    puts 'Connecting to PostgreSQL database.'
  end

  def self.read_input
    puts 'Input user`s first name:'
    first_name = gets.chomp.to_s
    puts 'Input user`s last name:'
    last_name = gets.chomp.to_s
    puts 'Input user`s balance:'
    balance = gets.chomp.to_s
    [first_name, last_name, balance]
  end

  def self.parse_selection_params(parameters)
    args = []
    parameters.split(' ').each do |value|
      temp = value.split('=')
      if (temp.first == 'first-name' || temp.first == 'last-name' || temp.first == 'balance') && temp.last != temp.first
        args.push({ temp.first => temp.last })
      end
    end

    args.reduce Hash.new, :merge
  end

  def self.parse_command
    input = Readline.readline('> ', true)
    command_input = input.split(' ', 2)
    command = command_input.first

    parameters = command_input.length == 2 ? command_input.last : ''

    [command, parameters]
  end

  def self.form_where_clause(parameters)
    keys = parse_selection_params(parameters)
    form_query(keys, 'WHERE ', 'AND')
  end

  def self.form_set_clause(parameters)
    keys = parse_selection_params(parameters)
    form_query(keys, 'SET ', ',')
  end

  def self.form_output(result)
    string = ''
    result.to_a.each do |instance|
      string << '---' * 10
      string << "\n"
      instance.each { |key, value| string << "#{key}: #{value}\n" }
    end
    puts string
  end

  def self.form_query(keys, keyword, delimiter)
    query = keyword
    keys.each_pair do |key, value|
      key = key.sub('-', '_') if key.include? '-'
      query << "#{key}='#{value}' #{delimiter} "
    end

    query = query[0...-(delimiter.length + 1)]
  end
end
