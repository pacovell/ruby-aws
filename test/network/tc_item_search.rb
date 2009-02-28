#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../test_helper'

class TestItemSearch < Test::Unit::TestCase

  def setup
    @rg = ResponseGroup.new( :Small )
    @req = Request.new(@@key_id, @@associates_id)
    @req.locale = 'uk'
    @req.cache = false
  end

  def test_item_search
    is = ItemSearch.new( 'Books', { 'Title' => 'Ruby' } )
    response = @req.search( is, @rg )

    results = response.kernel

    # Ensure we got some actual results back.
    #
    assert( results.size > 0 )

  end

end
