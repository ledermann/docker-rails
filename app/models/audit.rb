class Audit < PaperTrail::Version
  self.table_name = :audits
  belongs_to :user, foreign_key: 'whodunnit', optional: true
end
