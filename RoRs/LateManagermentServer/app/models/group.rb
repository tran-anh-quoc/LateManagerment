class Group < ActiveRecord::Base
  has_many :users

  # Define contanst Groups
  ADMIN   = 'admin'.freeze
  CLIENT = 'client'.freeze
  SYSTEM = 'system'.freeze
end
