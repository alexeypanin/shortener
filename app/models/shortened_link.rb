class ShortenedLink < ApplicationRecord
  validates :transitions, numericality: { only_integer: true,
                                          greater_than_or_equal_to: 0 }

  validates :shortened_url, uniqueness: true
  validates :original_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), uniqueness: true

  has_many :link_visits
end
