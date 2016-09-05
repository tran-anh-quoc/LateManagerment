# app/policies/application_policy.rb
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    writable?
  end

  def new?
    create?
  end

  def update?
    writable?
  end

  def edit?
    writable?
  end

  def destroy?
    writable?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  private
    def readable?
      @user.nil? ? false : @user.client?
    end

    def writable?
      @user.nil? ? false : @user.admin?
    end
end
