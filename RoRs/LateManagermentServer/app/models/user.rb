# app/models/user.rb
class User < ActiveRecord::Base
  # For trailing White spaces
  strip_attributes

  belongs_to :group
  has_many :messages

  # Soft delete with paranoia
  acts_as_paranoid

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User
  devise :omniauthable, :omniauth_providers => [:google_oauth2]

  validates :authentication_token, uniqueness: true, allow_nil: true
  validates :name, :nickname, presence: true,
            length: { maximum: 255 }
  validates :phone_number, presence: true,
            length: { maximum: 255 }

  after_create :generate_authentication_token

  scope :sorted_by_newest, lambda { order(:created_at => :desc) }
  scope :with_name_phone, lambda { |name_phone|
    name_phone[0] = '' unless name_phone[0] != '0'
    if name_phone.is_a? Array
      where(name_phone.map { |i| "users.name LIKE '%#{i}%' OR users.phone_number LIKE '%#{i}%'" }.join(' OR '))
    else
      where('users.name LIKE ? OR users.phone_number LIKE ?', "%#{name_phone}%", "%#{name_phone}%")
    end
  }

  def self.find_or_create_user_for_oauth(auth)
    user = User.find_by(:provider => auth.provider, :uid => auth.uid)

    if user.nil?
      user = User.new(
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.name,
        nickname: auth.info.name,
        email: auth.info.email,
        image: auth.info.image,
        password: Devise.friendly_token[0, 20],
        group_id: Group.find_by_name(Group::CLIENT).id,
        sign_in_count: 1,
        phone_number: '+84000000000',
        current_sign_in_at: DateTime.now,
        last_sign_in_at: DateTime.now,
        current_sign_in_ip: auth.ip_address,
        last_sign_in_ip: auth.ip_address
      )
      user.save!
    else
      user.update_attributes({
        sign_in_count: user.sign_in_count + 1,
        last_sign_in_at: user.current_sign_in_at,
        current_sign_in_at: DateTime.now,
        last_sign_in_ip: user.current_sign_in_ip,
        current_sign_in_ip: auth.ip_address
      })
    end

    user
  end

  def ensure_authentication_token
    self.authentication_token || generate_authentication_token
  end

  def generate_authentication_token
    loop do
      old_token = self.authentication_token
      new_token = SecureRandom.urlsafe_base64(24).tr('+/=lIO0', 'pqrsxyz')
      next if old_token == new_token
      break new_token if (self.update!(authentication_token: new_token) rescue false)
    end
  end

  def delete_authentication_token
    self.update(authentication_token: nil)
  end

  def admin?
    self.has_group? Group::ADMIN
  end

  def client?
    [Group::ADMIN, Group::CLIENT, Group::SYSTEM].include?(self.group.try(:name))
  end

  def system?
    [Group::SYSTEM].include?(self.group.try(:name))
  end

  def has_group?(group)
    self.group.try(:name).downcase == group
  end
end
