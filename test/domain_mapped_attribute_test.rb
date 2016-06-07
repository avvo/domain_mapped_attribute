require 'test_helper'

class DomainMappedAttributeTest < ActiveSupport::TestCase

  def test_that_it_has_a_version_number
    refute_nil ::DomainMappedAttribute::VERSION
  end

  def test_creating_record_can_find_mapping
    review = Review.new({
      title: "Great!",
      body: "This place is amazing!",
      restaurant_name: "McDonald's"
    })

    assert review.save, review.errors.full_messages.to_sentence

    mcd = restaurants(:mcd)
    assert_equal mcd.id, review.restaurant_id
    assert_equal "McDonald's", review.restaurant_name
  end

  def test_mapped_record_should_return_the_user_input_if_present
    review = reviews(:mapped_with_string)
    assert_equal "Some string", review.restaurant_name

  end

  def test_mapped_record_should_return_domain_value_if_user_input_is_missing
    review = reviews(:mapped_without_string)
    assert_equal "Burger King", review.restaurant_name
  end
end
