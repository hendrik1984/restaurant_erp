class Permission < ApplicationRecord
  has_many :role_permissions, dependent: :destroy
  has_many :roles, through: :role_permissions

  validates :module, presence: true
  validates :action, presence: true
  validates :action, uniqueness: { scope: :module }

  def key
    "#{self.module}/#{action}"
  end
end
