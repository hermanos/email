class Option < ActiveRecord::Base
  attr_accessible :option_name, :option_value, :user_id

  belongs_to :user

end
