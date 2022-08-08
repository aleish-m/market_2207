require 'date'

class Market
  attr_reader :name, :vendors, :date

  def initialize(name)
    @name = name
    @vendors = []
    @date = Date.today.strftime('%d/%m/%Y')
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.inventory.include?(item)
    end
  end

  def items_by_quantity
    items = Hash.new(0)
    @vendors.each do |vendor|
      vendor.inventory.each do |item, quantity|
        items[item] += quantity
      end
    end
    items
  end

  def total_inventory
    inventory = Hash.new { |h, k| h[k] = {} }
    items_by_quantity.each do |item, count|
      inventory[item] = {
        quantity: count,
        vendors: vendors_that_sell(item)
      }
    end
    inventory
  end

  def overstocked_items
    items_by_quantity.select do |item, quantity|
      quantity > 50 && vendors_that_sell(item).count > 1
    end.keys
  end

  def sorted_item_list
    items_by_quantity.keys.map do |item|
      item.name
    end.sort
  end
end
