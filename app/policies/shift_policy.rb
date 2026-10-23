class ShiftPolicy < ApplicationPolicy
  def index?
    admin? || manager?
  end

  def create?
    staff?
  end

  def update?
    admin? || manager?
  end
end