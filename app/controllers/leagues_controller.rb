class LeaguesController < ApplicationController
  before_action :set_available_competitions

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

    competition = Competition.find_by_code(league_params[:competition_code])
    @league.league_competitions.build(
      competition: competition,
      season: Season.find_by(competition: competition, current: true)
    )

    if @league.save
      redirect_to @league, notice: t('controllers.leagues.league_created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_available_competitions
    @available_competitions = Competition.where(code: %w[PL CL SA]).pluck(:code, :name, :emblem)
  end

  def league_params
    params.expect(league: %i[name competition_code])
  end
end
