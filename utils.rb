# module that contains utility for application
module ApplicationUtility
  def self.help_messages
    {
      'help' => 'help command prints the help screen.',
      'exit' => 'exit command exits the application.',
      'stats' => 'stats command prints number of users in usersdb.',
      'create' => 'command that create`s new record in database using user`s input.',
      'list' => 'list command shows all records in usersdb.',
      'edit' => 'edit command allows to edit record in usersdb.',
      'find' => 'find command allows to search record by given parameter.',
      'delete' => 'command delete`s one or multiple users by given parameter.'
    }
  end

  def self.commands
    {
      'help' => method(:print_help),
      'exit' => method(:exit),
      'stats' => method(:stats),
      'create' => method(:create),
      'list' => method(:list)
    }
  end
end
