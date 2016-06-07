require 'test_helper'

class ResolverTest < ActiveSupport::TestCase

  def test_can_resolve
    resolver = DomainMappedAttribute::Resolver.new(name_field: :name, klass: Restaurant)

    subway = restaurants(:subway)
    assert_equal subway.id, resolver.resolve(subway.name)
  end

end
