require 'json'

# Controller related for all operations to be done on picks data
class PicksController < ApplicationController
  before_action :set_pick, only: [:show, :edit, :update, :destroy]

  # GET /picks
  # GET /picks.json
  def index
    user = User.where(token: session[:user_token]).first
    if user.nil?
      redirect_to '/'
      return
    end

    pooler = Pooler.where(user_id: user.id).first
    @max_season = (Pick.all.max_by do |x|
      x.season
    end)
    @max_season = !@max_season.nil? ? @max_season.season : Date.today.year

    data = Pick.where(pooler_id: pooler._id, season: @max_season).order_by(week: 1).to_a
    @picks = []

    (0..20).each do |i|
      @picks[i] = data.detect { |p| p.week == i + 1 }
    end
  end

  # GET /picks/1
  # GET /picks/1.json
  def show
    user = User.where(token: session[:user_token]).first
    if user.nil?
      redirect_to '/'
      return
    end

    @pooler_name = Pooler.where(user_id: user.id).first.name

    picks = @pick.parse_picks
    @picks_data = get_week(@pick.season.to_s, @pick.week.to_s)['events'].each_with_index.map do |game, i|
      {
        game: {
          away_code: get_shortname(game['strAwayTeam']),
          home_code: get_shortname(game['strHomeTeam'])
        },
        pick: picks.is_a?(Hash) ? picks[game['idEvent']] : picks[i]
      }
    end
  end

  # GET /picks/2020/1
  def show_week
    user = User.where(token: session[:user_token]).first
    if user.nil?
      redirect_to '/'
      return
    end

    pool = Pooler.where(user_id: user.id).first.pool
    @poolers_data = pool.poolers.map do |pooler|
      p = Pick.where(season: params[:season], week: params[:week], pooler_id: pooler.id).first
      {
        pooler_name: pooler.name,
        picks: !p.nil? ? p.parse_picks : nil
      }
    end

    @picks_data = get_week(params[:season], params[:week])['events'].each_with_index.map do |game, i|
      {
        game: game['strEventAlternate'],
        picks: @poolers_data.map do |p|
          if !p[:picks].nil?
            p[:picks].is_a?(Hash) ? p[:picks][game['idEvent']] : p[:picks][i]
          end
        end
      }
    end
  end

  # GET /picks/2020
  def show_season
    # add logic to show the picks in a better way
    # maybe get the picks for all poolers in pool
    @pick = Pick.where(season: params[:season]).first
  end

  # GET /picks/new
  def new
    @pick = Pick.new
    @pick.season = params[:season]
    @pick.week = params[:week]

    user = User.where(token: session[:user_token]).first
    if user.nil?
      redirect_to '/'
      return
    end
    pooler = Pooler.where(user_id: user.id).first
    @favTeam = pooler.favTeam

    @week_data = get_week(params[:season], params[:week])['events'].map do |x|
      x[:home_code] = get_shortname(x['strHomeTeam'])
      x[:away_code] = get_shortname(x['strAwayTeam'])
      x
    end
  end

  # GET /picks/1/edit
  def edit
    puts '[Picks][Edit]'
  end

  # POST /picks
  # POST /picks.json
  def create
    @pick = Pick.new
    params = pick_params['pick']

    @pick.season = params['season']
    @pick.week = params['week']

    user = User.where(token: session[:user_token]).first
    if user.nil?
      redirect_to '/'
      return
    end

    pooler = Pooler.where(user_id: user.id).first
    @pick.pooler_id = pooler._id

    # Set the pick string here based on data
    @pick.pickstring = params['data'].to_json

    respond_to do |format|
      if @pick.save
        # Redirect properly with season, week params
        format.html { redirect_to @pick, notice: 'Pick was successfully created.' }
        format.json { render :show, status: :created, location: @pick }
      else
        format.html { render :new }
        format.json { render json: @pick.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /picks/1
  # PATCH/PUT /picks/1.json
  def update
    respond_to do |format|
      if @pick.update(pick_params)
        format.html { redirect_to @pick, notice: 'Pick was successfully updated.' }
        format.json { render :show, status: :ok, location: @pick }
      else
        format.html { render :edit }
        format.json { render json: @pick.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /picks/1
  # DELETE /picks/1.json
  def destroy
    @pick.destroy
    respond_to do |format|
      format.html { redirect_to picks_url, notice: 'Pick was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pick
    @pick = Pick.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def pick_params
    # params.require(:pick).permit(:season, :week, :pickstring, :pooler_id, :data)
    params
  end
end
