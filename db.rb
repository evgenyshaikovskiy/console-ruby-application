require 'pg'

begin
  con = PG.connect :dbname => 'usersdb', :user => 'yauheni', :password => 'password123'
rescue PG::Error => e
  puts e.message
ensure
  # closes connection if con is not nil
  # similar to if con con.close
  con&.close
end
