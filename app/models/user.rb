class User < ApplicationRecord
  # enumerations
  enum :status, %i[active inactive].index_with(&:to_s)
  enum :kind, %i[promoter supervisor administrator].index_with(&:to_s)

  # validators
  validates :name, presence: true, length: { maximum: 100 }
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :kind, presence: true, inclusion: { in: kinds.keys }
end
