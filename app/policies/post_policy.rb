class PostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user&.is_admin?
  end

  def new?
    create?
  end

  def update?
    user&.is_admin?
  end

  def edit?
    update?
  end

  def destroy?
    user&.is_admin?
  end
end
