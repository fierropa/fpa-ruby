class ComparisonsController < ApplicationController
  before_action :set_comparison, only: [:show, :update, :destroy]

  # GET /comparisons
  # GET /comparisons.json
  def index
    @comparisons = Comparison.all
  end
  
  def new
    @comparison = Comparison.new
    2.times { @comparison.documents.build }
  end

  # GET /comparisons/1
  # GET /comparisons/1.json
  def show
  end

  # POST /comparisons
  # POST /comparisons.json
  def create
    @comparison = Comparison.new(comparison_params)

    if @comparison.save && @comparison.run
      flash[:success] = @comparison.exit_status_msg
      redirect_to @comparison
    else
      flash[:error] = @comparison.errors.methods
      render 'new'
    end
  end

  # PATCH/PUT /comparisons/1
  # PATCH/PUT /comparisons/1.json
  def update
    if @comparison.update(comparison_params) && @comparison.run
      redirect_to @comparison
    else
      render json: @comparison.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comparisons/1
  # DELETE /comparisons/1.json
  def destroy
    @comparison.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comparison
      @comparison = Comparison.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comparison_params
      params.require(:comparison).permit(:description, documents_attributes: [:file, :id])
    end
end
