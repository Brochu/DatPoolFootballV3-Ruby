class PoolersController < ApplicationController
  before_action :set_pooler, only: [:show, :edit, :update, :destroy]

  # GET /poolers
  # GET /poolers.json
  #def index
  #  @poolers = Pooler.all
  #end

  # GET /poolers/1
  # GET /poolers/1.json
  def show
  end

  # GET /poolers/new
  def new
    @pooler = Pooler.new
  end

  # GET /poolers/1/edit
  def edit
  end

  # POST /poolers
  # POST /poolers.json
  def create
    @pooler = Pooler.new(pooler_params)

    @user = User.where(token: session[:user_token]).first
    @pooler.pool_id = BSON::ObjectId.new
    @pooler.user_id = @user.id

    respond_to do |format|
      if @pooler.save
        format.html { redirect_to @pooler, notice: 'Pooler was successfully created.' }
        format.json { render :show, status: :created, location: @pooler }
      else
        format.html { render :new }
        format.json { render json: @pooler.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /poolers/1
  # PATCH/PUT /poolers/1.json
  def update
    respond_to do |format|
      if @pooler.update(pooler_params)
        format.html { redirect_to @pooler, notice: 'Pooler was successfully updated.' }
        format.json { render :show, status: :ok, location: @pooler }
      else
        format.html { render :edit }
        format.json { render json: @pooler.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /poolers/1
  # DELETE /poolers/1.json
  #def destroy
  #  @pooler.destroy
  #  respond_to do |format|
  #    format.html { redirect_to poolers_url, notice: 'Pooler was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pooler
      @pooler = Pooler.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pooler_params
      params.require(:pooler).permit(:name, :favTeam)
    end
end
