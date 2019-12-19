class Product < ApplicationRecord
  belongs_to :user

  validates :title, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 },
                    presence: true

  scope :filter_by_title, ->(keyword) { where('lower(title) LIKE ?', "%#{keyword.downcase}%") }
  scope :above_or_equal_to_price, ->(price) { where('price >= ?', price) }
  scope :below_or_equal_to_price, ->(price) { where('price <= ?', price) }
  scope :recent, -> { order(:updated_at) }

  # @return [ActiveRecord::Relation]
  def self.search(params = {})
    products = params[:product_ids].present? ? Product.where(id: params[:product_ids]) : Product.all
    products = products.filter_by_title(params[:keyword]) if params[:keyword]
    if params[:min_price]
      products = products.above_or_equal_to_price(params[:min_price].to_f)
    end
    if params[:max_price]
      products = products.below_or_equal_to_price(params[:max_price].to_f)
    end
    products = products.recent if params[:recent]
    products
  end

end
