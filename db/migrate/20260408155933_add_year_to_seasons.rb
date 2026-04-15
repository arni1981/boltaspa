class AddYearToSeasons < ActiveRecord::Migration[8.2]
  def change
    # NOTE: We use 'stored: true' because Postgres requires generated
    # columns to be stored physically to be used in indexes.
    add_column :seasons, :year, :virtual,
               type: :integer,
               as: 'EXTRACT(YEAR FROM start_date)',
               stored: true

    # Now you can index it for those fast Matchday Switcher lookups
    add_index :seasons, :year
  end
end
