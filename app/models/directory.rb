class Directory < ActiveRecord::Base
  has_and_belongs_to_many :purchases, -> { uniq }
  has_many :children, :class_name => 'Directory', :foreign_key => "parent_id"
  belongs_to :parent, :class_name => 'Directory', :foreign_key => "parent_id"
  has_and_belongs_to_many  :purchases
  before_save :check_parent
  validates :name, uniqueness: true
  def self.find_or_create name
    dir = Directory.find_by_name(name)
    dir = Directory.create(name:name, parent_id: Directory.root.id) unless dir
    return dir
  end

  def self.root
    return Directory.where("parent_id IS NULL").first
  end

  def self.update_full_path options={}
    
    all_need_update_set = if options[:update_all]
      Directory.all.to_set
    else
      Directory.where('datetime(updated_at) > datetime(path_update) OR path_update IS NULL OR full_path IS NULL').to_set
    end

    infinitive_loop = 0    
    while !all_need_update_set.empty?
      current = all_need_update_set.first
      parent = current.parent
      current.full_path = parent.try(:full_path).to_s+parent.try(:id).to_s+'/'
      current.path_update = Time.now.utc.to_s(:db)
      current.save      
      all_need_update_set.delete(current)
      all_need_update_set.merge(current.children.to_a)
    end
  end

  def self_and_all_children
    Directory.update_full_path
    Directory.where("full_path LIKE ? || '%' OR id = ?", self.full_path+self.id.to_s+'/', self.id)
  end  

  def all_purchases
    Purchase.which_belongs_to(self.self_and_all_children.pluck(:id))    
  end

  def check_parent
    if self.parent == nil && self.id != Directory.root.id
      self.parent = Directory.root
    end
  end
end
