class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  # GET /purchases
  # GET /purchases.json
  def index    
    @date = params[:date].try(:to_date) || Date.today
    @purchases = Purchase.where("date = ?",@date).includes(:directories)
    @new_purchase = Purchase.new(date: @date)
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
  end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
  end

  # POST /purchases
  # POST /purchases.json
  def create    
    @purchase = Purchase.new(purchase_params)    
    if !params[:purchase][:directories].empty? && @purchase.save
      # create dir assosiations
      params[:purchase][:directories].split(',').each do |name|
        @purchase.directories<<Directory.find_or_create(name);
      end      
      render :json => {status: 'created', edit_destroy_link: purchase_path(@purchase)}.to_json
    else
      render :json => {status: 'fail'}.to_json
    end    
  end

  # PATCH/PUT /purchases/1
  # PATCH/PUT /purchases/1.json
  def update
    if !params[:purchase][:directories].empty? && @purchase.update(purchase_params)
      # create dir assosiations
      @purchase.directories.delete_all
      params[:purchase][:directories].split(',').each do |name|
        @purchase.directories<<Directory.find_or_create(name);
      end
      render :json => {status: 'updated'}.to_json
    else
      render :json => {status: 'fail'}.to_json
    end
    
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy    
    if @purchase.destroy
      render json: 'Destroyed'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_params
      pur_params = params.require(:purchase).permit(:cost, :name, :directories_purchases_id,:date)
      pur_params[:date] = pur_params[:date].to_date
      return pur_params
    end
end
