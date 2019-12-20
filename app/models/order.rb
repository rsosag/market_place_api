class Order < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  validates :total, numericality: { greater_than_or_equal_to: 0 }
  validates :total, presence: true
  before_validation :set_total!

  validates_with EnoughProductsValidator

  def set_total!
    self.total = products.map(&:price).sum
  end

  # @yield [Placement] placements build
  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      placement = placements.build(product_id: product_id_and_quantity[:product_id],
                                   quantity: product_id_and_quantity[:quantity])
      yield placement if block_given?
    end
  end
end
