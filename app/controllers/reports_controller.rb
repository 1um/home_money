class ReportsController < ApplicationController
  def index
    
  end

  def dirsum
    dirs = ActiveSupport::JSON.decode( params[:directories])
    dir_names = dirs.map{|hash| hash["text"]}
    top_dir =  Directory.where("name in (?)",dir_names);
    dir_ids = top_dir.map{|e| e.self_and_all_children.pluck(:id)}.flatten.uniq    
    purs =  Purchase.which_belongs_to(dir_ids).group(:date).sum(:cost)
    return_val = purs.map {|k, v| [k.to_datetime.to_i*1000, v] }    
    render json: return_val.to_json
  end

  def dirchildsum
    dir = Directory.find_by_name(params[:directory])
    rez = []
    childs = dir.children
    childs.each{|child| rez<<{label:child.name, data: child.all_purchases.sum(:cost)}}
    rez<<{label: "Без категории", data: dir.purchases.sum(:cost)}
    render json: rez.to_json
  end

end
