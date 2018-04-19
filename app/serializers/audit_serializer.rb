class AuditSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :event, :whodunnit

  def whodunnit
    object.user&.email || object.whodunnit
  end
end
