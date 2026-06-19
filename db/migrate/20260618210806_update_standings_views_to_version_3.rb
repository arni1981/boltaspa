class UpdateStandingsViewsToVersion3 < ActiveRecord::Migration[8.1]
  def change
    update_view :standings_views, version: 3, revert_to_version: 2
  end
end
