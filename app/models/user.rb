class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :role
  has_many :role_permissions, through: :role
  has_many :permissions, through: :role_permissions
  has_many :shifts, dependent: :destroy

  enum :status, {active: 0, inactive: 1}

  validates :name, presence: true
  validates :email, presence: true, if: :customer?
  validates :username, presence: true, if: :staff?
  validate :email_format_if_customer

  scope :staff_members, -> { where.not(role: Role.find_by(name: "Customer")) }
  
  def customer?
    puts role&.name
    role&.name == "Customer"
  end

  def staff?
    role.present? && !customer?
  end

  def admin?
    puts role&.name
    role&.name == "Admin"
  end

  def manager?
    puts role&.name
    role&.name == "Manager"
  end

  def can?(permission_key)
    return false unless active?
    permissions.exists?(module: permission_key.split("/").first, action: permission_key.split("/").last)
  end

  # Pin management (manager only)
  def set_pin(raw_pin)
    self.pin_digest = BCrypt::Password.create(raw_pin)
  end
  
  def valid_pin?(raw_pin)
    return false if pin_digest.blank?
    BCrypt::Password.new(pin_digest) == raw_pin
  end

  protected

  def email_required? # this method is to overide devise validatable module
    customer? # Only customers required email; staff do not.
  end


  private

  def email_format_if_customer
    return unless customer? && email.present?
    errors.add(:email, "is invalid") unless email.match?(URI::MailTo::EMAIL_REGEXP)
  end
end
