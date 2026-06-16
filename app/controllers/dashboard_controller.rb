class DashboardController < ApplicationController
  def show
    redirect_to onboarding_path and return if Current.user.leagues.none?

    upcoming_matches = Current.user.matches.upcoming.ordered.limit(15)
    @next_match = upcoming_matches.first

    @leagues = Current.user
                      .leagues
                      .includes(league_competitions: %i[competition season standings])
                      .includes(:members)

    # Fetch active or recently completed matches across your leagues for today
    @recent_results = Match.where(kickoff_at: 24.hours.ago..Date.today.at_end_of_day)
                           .order(kickoff_at: :desc)

    # Map predictions for instantaneous tracking cards evaluation
    @predictions_map = Current.user.predictions_map(@recent_results)
  end
end
