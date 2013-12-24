class DirectoriesController < ApplicationController
  before_action :set_directory, only: [:show, :edit, :update, :destroy]

  def index
    @directories = Directory.all
  end

  def show
  end

  def new
    @directory = Directory.new
  end


  def edit
  end

  def create    
    @directory = Directory.new(directory_params)
    if @directory.save
      render :json => {status: 'ok', dir: @directory}.to_json  
    else
      render :json => {status: 'fail', errors: @directory.errors}.to_json  
    end
    
  end


  def update
    respond_to do |format|
      if directory_params[:name].empty?
        parent = @directory.parent
        parent.purchases<<@directory.purchases
        parent.children<<@directory.children
        @directory.destroy
      else
        if @directory.update(directory_params)
          format.html { redirect_to @directory, notice: 'Directory was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @directory.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @directory.destroy
    respond_to do |format|
      format.html { redirect_to directories_url }
      format.json { head :no_content }
    end
  end

  def search    
    res = Directory.where('name like :q',q:'%'+params[:q].to_s+'%')
    # check if :q already in respond_to
    unless params[:exist_only]=="true" || res.map(&:name).include?(params[:q])
      res<<Directory.new(name:params[:q])
    end
    json_res = res.map{|dir| dir.name}.to_json
    render :json => json_res
  end

  def set_parent 
    child = Directory.find_by_name(params[:child_name])
    parent = params[:parent_name]!='null' ? Directory.find_by_name(params[:parent_name]) : Directory.root
    if child&&parent
      child.parent = parent              
      render json: child.save
    else
      render json: 'Not Found'
    end
  end

  private
    def set_directory
      @directory = Directory.find(params[:id])
    end

    def directory_params
      params.require(:directory).permit(:name, :directories_purchases_id)
    end
end
