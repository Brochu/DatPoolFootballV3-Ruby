class PoolsController < ApplicationController
  before_action :set_pool, only: [:show, :edit, :update, :destroy]

  # GET /pools
  # GET /pools.json
  def index
    user = User.where(token: session[:user_token]).first
    if (user == nil) then
      redirect_to '/'
      return
    end

    @pool = Pooler.where(user_id: user.id).first.pool
    @poolers = @pool.poolers.to_a

    if (params[:season] != nil && params[:week] != nil) then
      @week_info = {
        season: params[:season],
        week: params[:week]
      }
    else
      @week_info = find_current_week(@poolers)
    end

    if (params[:season_total] == nil) then
      @week_data = get_week(@week_info[:season], @week_info[:week])["events"].map do |x|
        x[:home_code] = get_shortname(x["strHomeTeam"])
        x[:home_won] = x["intHomeScore"].to_i > x["intAwayScore"].to_i

        x[:away_code] = get_shortname(x["strAwayTeam"])
        x[:away_won] = x["intAwayScore"].to_i > x["intHomeScore"].to_i
        x
      end
      picks_data = @poolers.map do |pooler|
        {
          :p => pooler,
          :picks => pooler.picks.where(season: @week_info[:season], week: @week_info[:week]).first
        }
      end

      @results = calculate_week_results(picks_data, @week_data)
      @totals = @results.map do |r|
        r.reduce(0) { |t, c| t = t + c }
      end
    else
      @results = (1..@week_info[:week]).map do |w|
        week_data = get_week(@week_info[:season], w)["events"].map do |x|
          x[:home_code] = get_shortname(x["strHomeTeam"])
          x[:home_won] = x["intHomeScore"].to_i > x["intAwayScore"].to_i

          x[:away_code] = get_shortname(x["strAwayTeam"])
          x[:away_won] = x["intAwayScore"].to_i > x["intHomeScore"].to_i
          x
        end
        picks_data = @poolers.map do |pooler|
          {
            :p => pooler,
            :picks => pooler.picks.where(season: @week_info[:season], week: w).first
          }
        end

        calculate_week_results(picks_data, week_data).map do |r|
          r.reduce(0) do |t, c|
            if (c >= 0) then
              t = t + c
            else
              t = t + 0
            end
          end
        end
      end

      @totals = @poolers.each_with_index.map do |x, i|
        @results.reduce(0) do |t, a|
          t = t + a[i]
        end
      end
    end
  end

  # GET /pools/1
  # GET /pools/1.json
  def show
  end

  # GET /pools/new
  def new
    @pool = Pool.new
  end

  # GET /pools/1/edit
  def edit
  end

  # POST /pools
  # POST /pools.json
  def create
    @pool = Pool.new(pool_params)

    respond_to do |format|
      if @pool.save
        format.html { redirect_to @pool, notice: 'Pool was successfully created.' }
        format.json { render :show, status: :created, location: @pool }
      else
        format.html { render :new }
        format.json { render json: @pool.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pools/1
  # PATCH/PUT /pools/1.json
  def update
    respond_to do |format|
      if @pool.update(pool_params)
        format.html { redirect_to @pool, notice: 'Pool was successfully updated.' }
        format.json { render :show, status: :ok, location: @pool }
      else
        format.html { render :edit }
        format.json { render json: @pool.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pools/1
  # DELETE /pools/1.json
  def destroy
    @pool.destroy
    respond_to do |format|
      format.html { redirect_to pools_url, notice: 'Pool was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pool
      @pool = Pool.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pool_params
      params.require(:pool).permit(:name, :motp)
    end

    def find_current_week(poolers)
      t = poolers.reduce({ :season => -1, :week => -1}) do |maxes, pooler|
        max_season = pooler.picks.max_by { |p| p.season }
        if (max_season != nil && max_season.season > maxes[:season]) then
          maxes[:season] = max_season.season
        end

        max_week = pooler.picks.max_by { |p| p.week }
        if (max_week != nil && max_week.week > maxes[:week]) then
          maxes[:week] = max_week.week
        end
        maxes
      end

      if (t[:season] == -1) then
        t[:season] = Date.today.year
      end
      if (t[:week] == -1) then
        t[:week] = 1
      end

      return t
    end

    def calculate_week_results(picks_data, week_data)
      picks_data.map do |e|
        if (e[:picks] == nil) then
          (0...week_data.size).map { |g| -1 }
        else
          picks = e[:picks].parse_picks
          week_data.each_with_index.map do |game, i|
            curr_pick = (e[:picks].json_picks?) ? picks[game["idEvent"]] : picks[i]

            if ((game[:away_won] && curr_pick==game[:away_code]) ||
              (game[:home_won] && curr_pick==game[:home_code])) then

              # pooler was right
              unique = picks_data.one? do |x|
                if (x[:picks] != nil) then
                  x_picks = x[:picks].parse_picks
                  other_current = (x[:picks].json_picks?) ? x_picks[game["idEvent"]] : x_picks[i]
                  other_current==curr_pick
                else
                  false
                end
              end

              (unique) ? 3 : 2
            else
              #pooler was wrong OR tie game OR no score
              (!game[:away_won] && !game[:home_won] && game["intAwayScore"]!=nil && game["intHomeScore"]!=nil) ? 1 : 0
            end
          end
        end
      end
    end
end
