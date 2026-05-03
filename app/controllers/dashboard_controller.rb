class DashboardController < ApplicationController
  def show
    redirect_to onboarding_path and return if Current.user.leagues.none?

    upcoming_matches = Current.user.matches.upcoming.ordered.limit(15)
    @next_match = upcoming_matches.first

    @leagues = Current.user
                      .leagues
                      .includes(league_competitions: %i[competition season standings])
                      .includes(:members)
  end
end
