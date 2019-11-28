class AuditSerializer < Panko::Serializer
  attributes :id, :created_at, :event, :whodunnit

  def whodunnit
    object.user&.email || object.whodunnit
  end
end
