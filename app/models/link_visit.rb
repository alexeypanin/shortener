class LinkVisit < ApplicationRecord
  belongs_to :shortened_link

  validates :shortened_link_id, presence: true
  validates :ip, presence: true, uniqueness: { scope: [:shortened_link_id] }
end
