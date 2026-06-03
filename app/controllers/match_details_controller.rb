class MatchDetailsController < ApplicationController
  def show
    @match = Match.find(params[:match_id])
    @home_team = @match.home_team
    @away_team = @match.away_team

    # Simple example queries for your sidebar statistics arrays
    # @home_standings = @home_team.current_standings_metrics
    # @away_standings = @away_team.current_standings_metrics
    # @recent_head_to_head = Match.where(home_team: [@home_team, @away_team],
    #                                    away_team: [@home_team,
    #                                                @away_team]).limit(5)
  end
end
