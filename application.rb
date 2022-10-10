require_relative 'utils'

# Singleton that defines application
class Application
  def initialize(db_manager)
    @help_messages = ApplicationUtility.help_messages
    @commands = {
      'help' => method(:print_help), 'exit' => method(:exit),
      'print-user-info' => method(:print_user_info), 'print-icons-info' => method(:print_icons_info),
      'print-pics-info' => method(:print_pics_info)
    }
    @is_running = true
    @db_manager = db_manager
  end

  def launch
    ApplicationUtility.print_welcome_message
    @db_manager.init_relations
    while @is_running
      command, parameters = ApplicationUtility.parse_command
      execute_command(command, parameters)
    end
  end

  private

  def print_user_info(_parameters)
    ApplicationUtility.form_output(@db_manager.select_users)
  end

  def print_icons_info(_parameters)
    ApplicationUtility.form_output(@db_manager.select_icons)
  end

  def print_pics_info(_parameters)
    ApplicationUtility.form_output(@db_manager.select_library_pictures)
  end

  def print_help(parameters)
    if @help_messages.key?(parameters)
      puts @help_messages[parameters]
    else
      puts 'List of available commands: '
      @help_messages.each { |key, value| puts "#{key} - #{value}" }
    end
  end

  def exit(_parameters)
    @is_running = false
    puts 'Closing the application...'
  end

  def execute_command(command, parameters)
    if @commands.key?(command)
      @commands[command].call(parameters)
    else
      print_help(command)
    end
  end
end
