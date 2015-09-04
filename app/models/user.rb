class User < ActiveRecord::Base
  IMAGE_SIZES = {xxl: '512x512#', xl: '256x256#', l: '128x128#', m: '64x64#', s: '32x32#'}

  devise :cas_authenticatable
  has_attached_file :avatar, styles: IMAGE_SIZES, default_url: '/images/image_missing_:style.png'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def cas_extra_attributes=(extra_attributes)
    self.attributes = extra_attributes.slice('first_name', 'last_name', 'email')
  end

  def name
    "#{first_name} #{last_name}"
  end
end

