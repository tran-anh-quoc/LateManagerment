# app/policies/user_policy.rb
class UserPolicy < ApplicationPolicy
  def index?
    writable?
  end

  def show?
    writable?
  end

  def edit?
    writable? && !record.system?
  end

  def update?
    writable? && !record.system?
  end

  def destroy?
    user.id != record.id && writable? && !record.system?
  end
end
