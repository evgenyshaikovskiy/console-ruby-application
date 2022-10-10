require 'pg'

# class that manages db connections
class DatabaseManager
  def initialize(db_name, username, password)
    @connection = PG.connect dbname: db_name, user: username, password: password
  rescue PG::Error => e
    puts e.message
  end

  def init_relations
    # create tables if they don't exist
    @connection.exec 'CREATE TABLE IF NOT EXISTS users(id SERIAL PRIMARY KEY, email VARCHAR(20), nickname VARCHAR(20));'

    @connection.exec 'CREATE TABLE IF NOT EXISTS users_info(first_name VARCHAR(20), last_name VARCHAR(20),
    birthdate DATE, sex VARCHAR(10), user_id INTEGER REFERENCES users(id));'

    @connection.exec 'CREATE TABLE IF NOT EXISTS pictures(id SERIAL PRIMARY KEY, url VARCHAR(50), alt_text VARCHAR(30));'

    @connection.exec 'CREATE TABLE IF NOT EXISTS users_to_pictures(picture_id INTEGER REFERENCES pictures(id),
    user_id INTEGER REFERENCES users(id), image_type VARCHAR(20));'
    delete_relations_data
    load_presaved_data
  rescue PG::Error => e
    puts e.message
  end

  private

  def delete_relations_data
    @connection.exec 'DELETE FROM users;'
    @connection.exec 'DELETE FROM users_info;'
    @connection.exec 'DELETE FROM pictures;'
    @connection.exec 'DELETE FROM users_to_pictures;'
    puts 'Data is cleared from all relations.'
  end

  def load_presaved_data
    # TODO: 
    # loading from CSV
    # AND adding to tables
  end
end
