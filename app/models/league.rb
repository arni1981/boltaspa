class League < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  has_many :comments, dependent: :destroy

  has_many :league_competitions
  has_many :competitions, through: :league_competitions
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  validates :invite_code, uniqueness: true
  validates :slug, uniqueness: true

  validates :name,
            presence: true,
            uniqueness: {
              scope: :owner_id,
              message: 'er nú þegar í notkun hjá þér. Veldu annað heiti.'
            }

  before_validation :generate_invite_code, on: :create
  before_validation :generate_slug, on: :create

  after_create :add_owner_as_member

  def to_s
    name
  end

  def to_param
    slug
  end

  private

  def generate_invite_code
    self.invite_code = "BOLTASPA-#{SecureRandom.hex(3).upcase}"
  end

  def generate_slug
    self.slug = "#{name.parameterize}-#{SecureRandom.hex(3)}"
  end

  def add_owner_as_member
    members << owner
  end
end
