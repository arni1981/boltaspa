Faker::Config.locale = :is

LeagueCompetition.destroy_all
League.destroy_all
User.destroy_all

User.create!(
  email_address: 'example@example.com',
  name: 'Árni G',
  password: 'nonni',
  password_confirmation: 'nonni'
)

User.create!(
  email_address: 'arnikg@example.com',
  name: 'Árni Kristófer',
  password: 'nonni',
  password_confirmation: 'nonni'
)

User.create!(
  email_address: 'bjarkir@example.com',
  name: 'Bjarki r',
  password: 'nonni',
  password_confirmation: 'nonni'
)

League.create!(
  name: 'nú?',
  owner_id: User.first.id
)

League.first.members << [User.second, User.third]

premier_league = Competition.find_by_code('PL')
LeagueCompetition.create!(
  league_id: League.first.id,
  competition: premier_league,
  season: Season.find_by(competition: premier_league, current: true)
)

puts 'Creating 2000 users...'
users = 2000.times.map do
  {
    name: Faker::Name.unique.name,
    email_address: Faker::Internet.unique.email,
    created_at: Time.current,
    updated_at: Time.current
  }
end
User.insert_all(users)

puts 'Creating 50 competitive leagues...'
leagues = 50.times.map do
  {
    name: "#{Faker::Sports::Football.team} #{%w[Deildin Klúbburinn Masters].sample}",
    invite_code: SecureRandom.base58(12).upcase,
    owner_id: User.all.sample.id,
    created_at: Time.current,
    updated_at: Time.current
  }
end
League.insert_all(leagues)

# Now, cross-join users into leagues (Memberships)
puts 'Populating memberships (approx 10 users per league)...'
all_user_ids = User.pluck(:id)
all_league_ids = League.pluck(:id)

memberships = []
all_league_ids.each do |l_id|
  # Give each league a random slice of users
  all_user_ids.sample(rand(5..15)).each do |u_id|
    memberships << {
      league_id: l_id,
      user_id: u_id,
      created_at: Time.current,
      updated_at: Time.current
    }
  end
end
Membership.insert_all(memberships)
