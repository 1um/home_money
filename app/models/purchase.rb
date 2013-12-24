class Purchase < ActiveRecord::Base
  has_and_belongs_to_many :directories, -> { uniq }
  validates :date, presence: true
  validates :cost, presence: true

  def self.which_belongs_to(directories_ids)
    Purchase.all.joins(:directories).where('"directories_purchases"."directory_id" IN (?)', directories_ids )
  end
end