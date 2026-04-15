class DashboardController < ApplicationController
  def show
    redirect_to onboarding_path if Current.user.leagues.none?

    @past_matches = Current.user.matches.with_results.ordered.limit(15)
    @upcoming_matches = Current.user.matches.upcoming.ordered.limit(15)
    @leagues = Current.user.leagues
    @next_match = @upcoming_matches.first

    @predictions_map = Current.user.predictions
                              .where(match_id: @past_matches.map(&:id))
                              .index_by(&:match_id)
  end
end
