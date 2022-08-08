require './lib/market'
require './lib/vendor'
require './lib/item'

describe Vendor do
  before :each do
    @market = Market.new('South Pearl Street Farmers Market')
    @vendor1 = Vendor.new('Rocky Mountain Fresh')
    @vendor2 = Vendor.new('Ba-Nom-a-Nom')
    @vendor3 = Vendor.new('Palisade Peach Shack')

    @item1 = Item.new({ name: 'Peach', price: '$0.75' })
    @item2 = Item.new({ name: 'Tomato', price: '$0.50' })
    @item3 = Item.new({ name: 'Peach-Raspberry Nice Cream', price: '$5.30' })
    @item4 = Item.new({ name: 'Banana Nice Cream', price: '$4.25' })

    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
  end
  describe 'initialize' do
    it 'Market exists' do
      expect(@market).to be_an_instance_of(Market)
    end

    it 'Market has a name' do
      expect(@market.name).to eq('South Pearl Street Farmers Market')
    end

    it 'Market starts with no vendors' do
      expect(@market.vendors).to eq([])
    end

    it 'Market can add vendors' do
      @market.add_vendor(@vendor1)
      expect(@market.vendors).to eq([@vendor1])
    end
  end

  describe 'Market Vendors' do
    before :each do
      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end

    it 'Market lists all the vendors' do
      expect(@market.vendors).to eq([@vendor1, @vendor2, @vendor3])
    end

    it 'Market lists all vendors that sell an item' do
      expect(@market.vendors_that_sell(@item1)).to eq([@vendor1, @vendor3])
      expect(@market.vendors_that_sell(@item4)).to eq([@vendor2])
    end
  end

  describe 'Market Inventory' do
    before :each do
      @vendor3.stock(@item3, 10)

      @market.add_vendor(@vendor1)
      @market.add_vendor(@vendor2)
      @market.add_vendor(@vendor3)
    end

    it 'Markets can find their total inventory' do
      expected_hash = {
        @item1 => {
          quantity: 100,
          vendors: [@vendor1, @vendor3]
        },
        @item2 => {
          quantity: 7,
          vendors: [@vendor1]
        },
        @item4 => {
          quantity: 50,
          vendors: [@vendor2]
        },
        @item3 => {
          quantity: 35,
          vendors: [@vendor2, @vendor3]
        }
      }
      expect(@market.total_inventory).to eq(expected_hash)
    end

    it 'Market can find overstocked items' do
      expect(@market.overstocked_items).to eq([@item1])
    end

    it 'Market can provide a sorted list of all items' do
      expect(@market.sorted_item_list).to eq(["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"])
    end
  end

  describe 'Market Date' do
    it 'Market has a Date it is created on' do
      allow(Date).to receive(:today).and_return(Date.parse("2022-7-22"))
      market = Market.new('South Pearl Street Farmers Market')
      expect(market.date).to eq('22/07/2022')
    end
  end
end
