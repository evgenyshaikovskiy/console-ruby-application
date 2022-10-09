# module that contains utility for application
module ApplicationUtility
  def self.help_messages
    {
      'help' => 'help command prints the help screen.',
      'exit' => 'exit command exits the application.',
      'stats' => 'stats command prints number of users in usersdb.',
      'create' => 'command that create`s new record in database using user`s input.',
      'list' => 'list command shows all records in usersdb.',
      'edit' => 'edit command allows to edit record in usersdb.
        Params: [<first-name>=value, <last-name>=value, <balance>=value].',
      'find' => 'find command allows to search record by given parameter.
        Params: [<first-name>=value, <last-name>=value, <balance>=value].',
      'delete' => 'command delete`s one or multiple users by given parameter.
        Params: [<first-name>=value, <last-name>=value, <balance>=value].'
    }
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
end
