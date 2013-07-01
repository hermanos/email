class User < ActiveRecord::Base
  attr_accessible :email, :password, :username
end
