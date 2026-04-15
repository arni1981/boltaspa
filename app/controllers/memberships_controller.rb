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
      @membership.errors.add(:base, 'Engin deild fannst með þessum kóða.')
      return render :new, status: :not_found
    end

    if @league.members.include?(Current.user)
      return redirect_to @league, notice: 'Þú ert nú þegar meðlimur í deildinni!'
    end

    @membership = @league.memberships.new(user: Current.user)

    if @membership.save
      redirect_to @league, info: 'Velkomin(n) í deildina!'
    else
      flash.now[:error] = 'Ekki tókst að skrá í deild.'
      render :new, status: :unprocessable_entity
    end
  end
end
