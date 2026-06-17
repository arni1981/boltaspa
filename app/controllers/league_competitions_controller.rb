class LeagueCompetitionsController < ApplicationController
  def show
    @league_competition = Current.user.leagues.find_by_slug!(params[:league_slug])
                                 .league_competitions.joins(:competition, :season)
                                 .find_by!(competitions: { code: params[:competition_code] },
                                           seasons: { year: params[:year] })

    @date = Time.zone.parse(params.fetch(:date, Time.zone.today.to_s))

    @matches = @league_competition.matches_for(@date)

    @active_tab = params.fetch(:tab, 'standings')

    read_status = Current.user.comments_read_statuses
                         .find_or_initialize_by(league_competition_id: @league_competition.id)

    if @active_tab == 'banter'
      read_status.tap do |read_status|
        read_status.last_read_at = Time.current
        read_status.save
      end
    end

    @unread_comments = if read_status.last_read_at
                         @league_competition.comments.maximum(:created_at) > read_status.last_read_at
                       else
                         false
                       end

    return unless params[:compare_user_id].present?

    @compare_user = @league_competition.league.members.find(params[:compare_user_id])
  end
end
