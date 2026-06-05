class MatchDetailsController < ApplicationController
  def show
    @match = Match.find(params[:match_id])
    @home_team = @match.home_team
    @away_team = @match.away_team

    # Pull the entire contextual table slice sorted perfectly by ranking order
    @group_rankings = SeasonRanking.where(
      season_id: @match.season_id,
      group: @match.group
    ).order(position: :asc).includes(:team)

    # Direct Head-to-Head history across recent finished fixtures
    @recent_head_to_head = Match.where(home_team: [@home_team, @away_team], away_team: [@home_team, @away_team])
                                .where.not(id: @match.id)
                                .where(status: 'FINISHED')
                                .order(kickoff_at: :desc)
                                .limit(5)
  end
end
