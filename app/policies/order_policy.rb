class OrderPolicy < ApplicationPolicy
  def create?
    customer? || user.nil? # nil = kiosk guest
  end

  def show?
    admin? || manager? || customer && record.user_id == user.id
  end

  def update_status?
    staff?
  end
end
