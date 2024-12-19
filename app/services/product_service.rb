class ProductService
  def self.find_by_id(id)
    Product.find_by(id: id)
  end
end