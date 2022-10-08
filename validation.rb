require_relative 'extensions'

# module that validates console inputs
module Validation
  def self.valid_user?(f_name, l_name, balance)
    f_name.length > 20 || l_name.length > 20 || !balance.i? || balance.to_i.negative? ? false : true
  end
end
