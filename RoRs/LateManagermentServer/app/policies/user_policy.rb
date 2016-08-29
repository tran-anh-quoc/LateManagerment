# app/policies/user_policy.rb
class UserPolicy < ApplicationPolicy
  def index?
    writable?
  end

  def show?
    writable?
  end

  def destroy?
    (user.id != record.id) && writable? && !user.system?
  end
end
