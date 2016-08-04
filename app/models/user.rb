class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true

  has_many :cats #,
    # primary_key: :id,
    # foreign_key: :user_id,
    # class_name: :Cat
  has_many :cat_rental_requests

  after_initialize :ensure_session_token

  attr_reader :password

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64(32)
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(32)
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    pw_dig = BCrypt::Password.new(self.password_digest)
    pw_dig.is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil unless user
    user.is_password?(password) ? user : nil
  end

  def self.find_by_session_token(session_token)
    User.find_by(session_token: session_token)
  end


end
