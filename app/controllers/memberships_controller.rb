class MembershipsController < ApplicationController
  def new
    handle_invite_code if params[:invite_code]
  end

  def create
    handle_invite_code
  end

  private

  def handle_invite_code
    @league = League.find_by(invite_code: params[:invite_code])

    if @league.nil?
      @membership = Membership.new
      @membership.errors.add(:base, t('controllers.memberships.league_not_found'))
      return render :new, status: :not_found
    end

    if @league.members.include?(Current.user)
      return redirect_to @league, notice: t('controllers.memberships.already_member')
    end

    @membership = @league.memberships.new(user: Current.user)

    if @membership.save
      redirect_to @league, info: t('controllers.memberships.welcome_message')
    else
      flash.now[:error] = t('controllers.memberships.join_failed')
      render :new, status: :unprocessable_entity
    end
  end
end
