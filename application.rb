# Singleton that defines application
class Application
  def initialize(db_manager)
    @is_running = true
    @db_manager = db_manager
  end

  def launch
    @db_manager.init_relations
  end
end
