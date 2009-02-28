#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../test_helper'

class TestAmazonBasics < Test::Unit::TestCase

  def test_uncamelise
    str = 'ALongStringWithACRONYM'
    uncamel_str = 'a_long_string_with_acronym'

    # Ensure uncamelisation of strings occurs properly.
    #
    assert_equal( uncamel_str, Amazon::uncamelise( str ) )
    assert_equal( 'asin', Amazon::uncamelise( 'ASIN' ) )

  end

end
