require File.expand_path(File.join(__FILE__, '../../test_helper'))

ATTRIBUTES = [
  :id, :watchlist_name, :entry_type, :matching_info, :confidence, :url, :notes,
  :title, :name_full, :alternate_names, :date_of_birth, :passport, :ssn,
  :address_street1, :address_street2, :address_city, :address_state,
  :address_postal_code, :address_country_code, :address_raw, :names, :births,
  :documents, :addresses
]

class WatchlistHitTest < Minitest::Test
  def test_watchlist_hit_initialization
    params = FactoryGirl.create(:match)
    hit = BlockScore::WatchlistHit.new(params)

    ATTRIBUTES.each do |attr|
      assert_respond_to hit, attr, "Failed to respond to: '#{attr}'"
    end
  end
end
