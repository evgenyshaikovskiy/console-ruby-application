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
    user_id INTEGER REFERENCES users(id), image_type VARCHAR(20), update_time TIMESTAMP);'
    delete_relations_data
    load_presaved_data
  rescue PG::Error => e
    puts e.message
  end

  def select_users
    @connection.exec 'SELECT users.email, users.nickname, users_info.first_name, users_info.last_name,
      users_info.birthdate, users_info.sex
      FROM users
      JOIN users_info ON users_info.user_id = users.id;'
  rescue PG::Error => e
    puts e.message
  end

  def select_icons
    # as an alterntive could be used without agg functions and grouping
    @connection.exec "WITH current_icons AS (SELECT picture_id, user_id, update_time
    FROM (SELECT user_id, picture_id, update_time, image_type, ROW_NUMBER()
    OVER (PARTITION BY user_id ORDER BY update_time DESC) AS rn FROM users_to_pictures WHERE image_type='icon')
    AS tmp WHERE rn=1),
    icons_info AS (SELECT url as current_icon_url, alt_text as current_icon_alt_text, update_time as updated_at,
    user_id FROM current_icons
    JOIN pictures ON pictures.id = current_icons.picture_id)
    SELECT email, nickname, string_agg(url, ', ') AS urls,
    string_agg(alt_text, ', ') AS alt_texts, current_icon_url, current_icon_alt_text
    FROM users_to_pictures
    JOIN users on users.id = users_to_pictures.user_id
    JOIN pictures on pictures.id = users_to_pictures.picture_id
    JOIN icons_info on icons_info.user_id = users.id
    WHERE users_to_pictures.image_type = 'icon'
    group by email, nickname, current_icon_url, current_icon_alt_text;"
  rescue PG::Error => e
    puts e.message
  end

  def select_library_pictures
    # as an alterntive could be used without agg functions and grouping
    @connection.exec "select email, nickname, string_agg(url, ', ') as urls, string_agg(alt_text, ', ') as alt_texts
    from users_to_pictures
    join users on users.id = users_to_pictures.user_id
    join pictures on pictures.id = users_to_pictures.picture_id
    where users_to_pictures.image_type = 'lib'
    group by email, nickname;"
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
