class LeaguesController < ApplicationController
  def index
    @leagues = Current.user.leagues
  end

  def show
    @league = Current.user.leagues.find_by_slug(params[:slug])
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(
      name: league_params[:name],
      owner: Current.user
    )

    Competition.where(code: %w[PL WC]).each do |competition|
      @league.league_competitions.build(
        competition: competition,
        season: Season.find_by(competition: competition, current: true)
      )
    end

    if @league.save
      redirect_to @league, notice: t('controllers.leagues.league_created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def league_params
    params.expect(league: %i[name])
  end
end
