json.array! @audits do |audit|
  json.extract! audit, :id, :created_at, :event

  json.whodunnit audit.user&.email || audit.whodunnit
end
