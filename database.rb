require 'pg'

# class that manages db connections
class DatabaseManager
  def initialize(db_name, username, password, csv_parser)
    @connection = PG.connect dbname: db_name, user: username, password: password
    @parser = csv_parser
  rescue PG::Error => e
    puts e.message
  end

  def init_relations
    # create tables if they don't exist
    @connection.exec 'CREATE TABLE IF NOT EXISTS users(id SERIAL PRIMARY KEY, email VARCHAR(40), nickname VARCHAR(30));'
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
    @connection.exec 'DELETE FROM users_to_pictures;'
    @connection.exec 'DELETE FROM users_info;'
    @connection.exec 'DELETE FROM users;'
    @connection.exec 'DELETE FROM pictures;'
    puts 'Data is cleared from all relations.'
  end

  def load_presaved_data
    load_relation('users')
    load_relation('users_info')
    load_relation('pictures')
    load_relation('users_to_pictures')
    puts 'Data is loaded from csv files'
  end

  def load_relation(relation_name)
    data = @parser.parse_file("data/#{relation_name}.csv")
    data.each do |record|
      insert_data_to_table(relation_name, record)
    end
  end

  def insert_data_to_table(table_name, data)
    @connection.exec "INSERT INTO #{table_name}(#{data.keys.join(',')})
    VALUES(#{data.values.map { |str| "'#{str}'" }.join(',')});"
  end
end
