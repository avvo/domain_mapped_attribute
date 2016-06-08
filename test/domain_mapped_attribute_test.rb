require 'test_helper'

class DomainMappedAttributeTest < ActiveSupport::TestCase

  def test_that_it_has_a_version_number
    refute_nil ::DomainMappedAttribute::VERSION
  end

  def test_creating_record_can_find_mapping
    review = Review.new({
      title: "Great!",
      body: "This place is amazing!",
      restaurant_name: "McDonald's",
      reviewed_by: "jeff"
    })

    assert review.save, review.errors.full_messages.to_sentence

    mcd = restaurants(:mcd)
    assert_equal mcd.id, review.restaurant_id
    assert_equal "McDonald's", review.restaurant_name

    jeff = reviewers(:jeff)
    assert_equal jeff.id, review.reviewer_id
    assert_equal "jeff", review.reviewed_by
  end

  def test_mapped_record_should_return_the_user_input_if_present
    review = reviews(:mapped_with_string)
    assert_equal "Some string", review.restaurant_name
  end

  def test_mapped_record_should_return_domain_value_if_user_input_is_missing
    review = reviews(:mapped_without_string)
    assert_equal "Burger King", review.restaurant_name
  end

  def test_unresolvable
    unknown = restaurants(:unknown)
    review = Review.new({
      title: "Great!",
      body: "This place is amazing!",
      restaurant_name: "something unknown",
      reviewed_by: "somebody"
    })

    assert review.save, review.errors.full_messages.to_sentence

    assert_equal unknown.id, review.restaurant_id
    assert_equal "something unknown", review.restaurant_name

    anon = reviewers(:anonymous)
    assert_equal anon.id, review.reviewer_id
    assert_equal "somebody", review.reviewed_by
  end

  def test_cannot_be_blank
    unknown = restaurants(:unknown)
    review = Review.new({
      title: "Ok",
      body: "Meh"
    })

    assert_equal false, review.save
    assert review.errors[:restaurant_name].present?
    assert_equal unknown.id, review.restaurant_id
  end

  def test_allowed_to_be_blank
    review = Review.new({
      title: "Great!",
      body: "This place is amazing!",
      restaurant_name: "something unknown"
    })

    assert review.save, review.errors.full_messages.to_sentence

    anon = reviewers(:anonymous)
    assert_equal anon.id, review.reviewer_id
    assert_nil review.reviewed_by
  end
end
