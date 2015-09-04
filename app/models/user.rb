class User < ActiveRecord::Base
  devise :cas_authenticatable

  def cas_extra_attributes=(extra_attributes)
    self.attributes = extra_attributes.slice('first_name', 'last_name', 'email')
  end

  def name
    "#{first_name} #{last_name}"
  end
end

