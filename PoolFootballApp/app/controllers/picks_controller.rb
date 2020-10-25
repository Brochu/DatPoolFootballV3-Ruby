class PicksController < ApplicationController
  before_action :set_pick, only: [:show, :edit, :update, :destroy]

  # GET /picks
  # GET /picks.json
  def index
    user = User.where(token: session[:user_token]).first
    if (user == nil) then
      redirect_to '/'
      return
    end

    pooler = Pooler.where(user_id: user.id).first
    @max_season = (Pick.where(pooler_id: pooler._id).max_by do |x| 
      x.season
    end)
    @max_season = (@max_season!=nil) ? @max_season.season : Date.today.year

    criteria = Pick.where(pooler_id: pooler._id, season: @max_season).order_by(week: 1)
    @picks = criteria.to_a

    (1..20).each do |i|
      @picks[i] = @picks[i]
    end
  end

  # GET /picks/1
  # GET /picks/1.json
  def show
    user = User.where(token: session[:user_token]).first
    if (user == nil) then
      redirect_to '/'
      return
    end

    @pooler_name = Pooler.where(user_id: user.id).first.name

    picks = @pick.pickstring.split("|")
    @picks_data = get_week(@pick.season, @pick.week)["events"].each_with_index.map do |game, i|
      {
        :game => game["strEventAlternate"],
        :pick => picks[i]
      }
    end
  end

  # GET /picks/2020/1
  def show_week
    # add logic to show the picks in a better way
    # maybe get the picks for all poolers in pool
    @pick = Pick.where(season: params[:season], week: params[:week]).first
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
    if (user == nil) then
      redirect_to '/'
      return
    end
    pooler = Pooler.where(user_id: user.id).first
    @favTeam = pooler.favTeam

    @week_data = get_week(params[:season], params[:week])["events"].map do |x|
      x[:home_code] = get_shortname(x["strHomeTeam"])
      x[:away_code] = get_shortname(x["strAwayTeam"])
      x
    end
  end

  # GET /picks/1/edit
  def edit
  end

  # POST /picks
  # POST /picks.json
  def create
    @pick = Pick.new
    params = pick_params["pick"]

    @pick.season = params["season"]
    @pick.week = params["week"]

    user = User.where(token: session[:user_token]).first
    if (user == nil) then
      redirect_to '/'
      return
    end

    pooler = Pooler.where(user_id: user.id).first
    @pick.pooler_id = pooler._id

    # Set the pick string here based on data
    str = get_week(@pick.season, @pick.week)["events"].reduce("") do |out, game|
      cur = params["data"][game["idEvent"]]

      if (cur != nil) then
        out << cur
      else
        out << "N/A"
      end

      out << "|"
    end

    @pick.pickstring = str.chop

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
