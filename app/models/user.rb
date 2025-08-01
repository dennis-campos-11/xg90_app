class User < ApplicationRecord
  LANGUAGES = %w[en es].freeze
  APPEARANCES = %w[light dark].freeze

  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 10 }, on: :reset_password
  validates :first_name, :last_name, presence: true
  validates :language, inclusion: { in: LANGUAGES }, allow_nil: true
  validates :appearance, inclusion: { in: APPEARANCES }, allow_nil: true

  def generate_password_reset_token!
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.current
    save!
  end

  def password_reset_token_valid?
    reset_password_sent_at && reset_password_sent_at > 2.hours.ago
  end

  def clear_password_reset_token!
    self.reset_password_token = nil
    self.reset_password_sent_at = nil
    save!
  end
end
