# Class to handle all process to Pools data
class PoolsController < ApplicationController
  before_action :set_pool, only: [:show, :edit, :update, :destroy]

  # GET /pools
  # GET /pools.json
  def index
    user = User.where(token: session[:user_token]).first
    if user.nil?
      redirect_to '/'
      return
    end

    @pool = Pooler.where(user_id: user.id).first.pool
    @poolers = @pool.poolers.to_a

    if !params[:season].nil? && !params[:week].nil?
      @week_info = {
        season: params[:season],
        week: params[:week]
      }
    else
      @week_info = find_current_week(@poolers)
    end

    if params[:season_total].nil?
      @week_data = get_week(@week_info[:season].to_s, @week_info[:week].to_s)['events'].map do |x|
        x[:home_code] = get_shortname(x['strHomeTeam'])
        x[:home_won] = x['intHomeScore'].to_i > x['intAwayScore'].to_i

        x[:away_code] = get_shortname(x['strAwayTeam'])
        x[:away_won] = x['intAwayScore'].to_i > x['intHomeScore'].to_i
        x
      end
      picks_data = @poolers.map do |pooler|
        {
          p: pooler,
          picks: pooler.picks.where(season: @week_info[:season], week: @week_info[:week]).first
        }
      end

      @results = calculate_week_results(picks_data, @week_data, @week_info[:week])
      @totals = @results.map do |r|
        r.reduce(0) { |t, c| t = t + c }
      end
    else
      @results = (1..@week_info[:week]).map do |w|
        week_data = get_week(@week_info[:season].to_s, w.to_s)['events'].map do |x|
          x[:home_code] = get_shortname(x['strHomeTeam'])
          x[:home_won] = x['intHomeScore'].to_i > x['intAwayScore'].to_i

          x[:away_code] = get_shortname(x['strAwayTeam'])
          x[:away_won] = x['intAwayScore'].to_i > x['intHomeScore'].to_i
          x
        end
        picks_data = @poolers.map do |pooler|
          {
            p: pooler,
            picks: pooler.picks.where(season: @week_info[:season], week: w).first
          }
        end

        calculate_week_results(picks_data, week_data, w).map do |r|
          r.reduce(0) do |t, c|
            t = c >= 0 ? t + c : t + 0
          end
        end
      end

      @totals = @poolers.each_with_index.map do |_, i|
        @results.reduce(0) do |t, a|
          t = t + a[i]
        end
      end
    end
  end

  # GET /pools/1
  # GET /pools/1.json
  def show
    puts '[Pools][Show]'
  end

  # GET /pools/new
  def new
    @pool = Pool.new
  end

  # GET /pools/1/edit
  def edit
    puts '[Pools][Edit]'
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
      t = poolers.reduce({ season: -1, week: -1 }) do |maxes, pooler|
        max_season = pooler.picks.max_by { |p| p.season }

        if !max_season.nil? && max_season.season > maxes[:season]
          maxes[:season] = max_season.season
          maxes[:week] = pooler.picks.where(season: max_season.season).max_by { |p| p.week }.week
        end

        maxes
      end

      t[:season] = Date.today.year if t[:season] == -1
      t[:week] = 1 if t[:week] == -1

      t
    end

    def calculate_week_results(picks_data, week_data, week)
      picks_data.map do |e|
        if e[:picks].nil?
          (0...week_data.size).map { |_| -1 }
        else
          picks = e[:picks].parse_picks
          week_data.each_with_index.map do |game, i|
            curr_pick = e[:picks].json_picks? ? picks[game['idEvent']] : picks[i]

            if (game[:away_won] && curr_pick == game[:away_code]) ||
               (game[:home_won] && curr_pick == game[:home_code])

              # pooler was right
              unique = picks_data.one? do |x|
                if !x[:picks].nil?
                  x_picks = x[:picks].parse_picks
                  other_current = x[:picks].json_picks? ? x_picks[game['idEvent']] : x_picks[i]
                  other_current == curr_pick
                else
                  false
                end
              end

              correctScore = get_correct_score(week)
              unique ? (1.5*correctScore).to_i : correctScore
            else
              # pooler was wrong OR tie game OR no score
              tied = (!game[:away_won] && !game[:home_won] &&
                      !game['intAwayScore'].nil? && !game['intHomeScore'].nil?)

              tied ? 1 : 0
            end
          end
        end
      end
    end

  def get_correct_score(week)
    n = week
    n = n.to_i if n.is_a? String

    return 2 if n < 18
    return 4 if n == 18
    return 6 if n == 19
    return 8 if n == 20
    return 10 if n == 21
  end
end
