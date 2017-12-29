class Visit < ApplicationRecord
  has_many :ahoy_events, class_name: "Ahoy::Event", dependent: :delete_all, inverse_of: :visit
  belongs_to :user, optional: true
end
