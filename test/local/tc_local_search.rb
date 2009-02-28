#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../test_helper'
require 'flexmock/test_unit'

class TestLocalSearch < Test::Unit::TestCase

  def setup
    @rg = ResponseGroup.new( :Small )
    @req = Request.new(@@key_id, @@associates_id)
    @req.locale = 'us'
    @req.cache = false
  end

  def test_movie_search
    flexmock(Amazon::AWS).should_receive(:get_page).and_return(read_cache('movies.xml'))
        
    is = ItemSearch.new( 'Books', { 'Title' => 'Ruby' } )
    response = @req.search( is, @rg )

    results = response.kernel

    # Ensure we got some actual results back.
    #
    assert( results.size == 10 )
  end

  def read_cache(file)
    data = File.open( File.dirname(__FILE__) + "/cache_files/#{file}" ).readlines.to_s
  end

end
