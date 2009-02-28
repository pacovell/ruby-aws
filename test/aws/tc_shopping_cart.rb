#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../test_helper'
require 'amazon/aws/shoppingcart'

include Amazon::AWS::ShoppingCart

class TestShoppingCart < Test::Unit::TestCase
  
  def setup
    # B00151HZA6 B000WC4AH0 B0006L16N8
    @asins = ['0805006001', '1599867419', '0689875886']
    @add_asins = ['8850700148', '0816648999', '1604596813', '0785822577', '044023865X']    
  end

  def test_shopping_cart1
    cart = Cart.new(@@key_id, @@associates_id)
    cart.locale = 'us'

    # Check that initial quantities are zero.
    #
    items = cart.items
    sfl_items = cart.saved_for_later_items
    assert_equal( 0, items.size )
    assert_equal( 0, sfl_items.size )

    # Create a cart with three items. The last two are given as multiple
    # single-element hashes. MergeCart is false.
    #
    cart.cart_create( :ASIN, @asins[0], 3, false,
		      { @asins[1] => 2 },
		      { @asins[2] => 1 } )
    items = cart.items

    # Check that the quantities match what we expect.
    #
    assert_equal( 3, items.size )
    item = items.find { |item| item.asin == @asins[0]  }
    assert_equal( '3', item.quantity[0] )
    item = items.find { |item| item.asin == @asins[1]  }
    assert_equal( '2', item.quantity[0] )
    item = items.find { |item| item.asin == @asins[2]  }
    assert_equal( '1', item.quantity[0] )

    # Check purchase URL.
    #

    # Check for correct Cart Id.
    #
    assert_match( /cart-id=#{cart.cart_id}/,
		  cart.purchase_url,
		  'Cart Id incorrect' )
 
    # Check for correct value of MergeCart.
    #
    assert_match( /MergeCart=False/,
		  cart.purchase_url,
		  'MergeCart is not False' )

    # Clear cart.
    #
    cart.cart_clear

    # Ensure that clearing the cart actually empties it.
    #
    assert_equal( 0, cart.cart_items.size )
  end

  def test_shopping_cart2
    cart = Cart.new(@@key_id, @@associates_id)
    cart.locale = 'us'

    # Create a cart with three items. The last two are given in a single
    # hash. MergeCart is true. Cart#create is used as an alias of
    # Cart#cart_create.
    #
    cart.create( :ASIN, @asins[0], 1, true,
		 { @asins[1] => 2,
		   @asins[2] => 3 } )
    items = cart.items

    # Check that the quantities match what we expect.
    #
    assert_equal( 3, items.size )
    item = items.find { |item| item.asin == @asins[0]  }
    assert_equal( '1', item.quantity[0] )
    item = items.find { |item| item.asin == @asins[1]  }
    assert_equal( '2', item.quantity[0] )
    item = items.find { |item| item.asin == @asins[2]  }
    assert_equal( '3', item.quantity[0] )

    # Check purchase URL.
    #

    # Check for correct Cart Id.
    #
    assert_match( /cart-id=#{cart.cart_id}/,
		  cart.purchase_url,
		  'Cart Id incorrect' )

    # Check for correct value of MergeCart.
    #
    assert_match( /MergeCart=True/,
		  cart.purchase_url,
		  'MergeCart is not True' )

    # Add some items.
    #
    cart.cart_add( :ASIN, @add_asins[0], 1,
		   { @add_asins[1] => 1,
		     @add_asins[2] => 4 },
		   { @add_asins[3] => 3,
		     @add_asins[4] => 2 } )

    # Check that the quantities match what we expect.
    #
    items = cart.items
    assert_equal( 8, items.size )
    item = items.find { |item| item.asin == @add_asins[0]  }
    assert_equal( '1', item.quantity[0] )
    item = items.find { |item| item.asin == @add_asins[1]  }
    assert_equal( '1', item.quantity[0] )
    item = items.find { |item| item.asin == @add_asins[2]  }
    assert_equal( '4', item.quantity[0] )
    item = items.find { |item| item.asin == @add_asins[3]  }
    assert_equal( '3', item.quantity[0] )
    item = items.find { |item| item.asin == @add_asins[4]  }
    assert_equal( '2', item.quantity[0] )

    # Modify an item quantity.
    #
    cart.cart_modify( :ASIN, @asins[0], 2 )
    items = cart.items
    assert_equal( 8, items.size )
    item = items.find { |item| item.asin == @asins[0]  }
    assert_equal( '2', item.quantity[0] )

    # Move item to 'Save For Later' area.
    #
    cart.cart_modify( :ASIN, @add_asins[0], 1, true )
    sfl_items = cart.saved_for_later_items
    assert_equal( 1, sfl_items.size )
    item = sfl_items.find { |item| item.asin == @add_asins[0]  }
    assert_equal( '1', item.quantity[0] )
    items = cart.items
    assert_equal( 7, items.size )
    assert( ! cart.active?( :ASIN, @add_asins[0] ) )

    # Move item back to 'Active' area.
    #
    cart.cart_modify( :ASIN, @add_asins[0], 1, false )
    items = cart.items
    assert_equal( 8, items.size )
    item = items.find { |item| item.asin == @add_asins[0]  }
    assert_equal( '1', item.quantity[0] )
    sfl_items = cart.saved_for_later_items
    assert_equal( 0, sfl_items.size )
    assert( ! cart.saved_for_later?( :ASIN, @add_asins[0] ) )

    # Remove an item.
    #
    cart.cart_modify( :ASIN, @add_asins[0], 0 )

    # Check that the number of items in the cart has been reduced by one.
    #
    items = cart.items
    assert_equal( 7, items.size )

    # Check that the item is no longer in the cart.
    #
    assert( ! cart.include?( :ASIN, @add_asins[0] ) )

    # Check that modifying non-existent item raises exception.
    #
    assert_raise( Amazon::AWS::ShoppingCart::CartError ) do
      cart.cart_modify( :ASIN, @add_asins[0], 1 )
    end

    # Move another item to the 'Save For Later' area.
    #
    cart.cart_modify( :ASIN, @asins[0], 2, true )
    items = cart.items
    assert_equal( 6, items.size )
    sfl_items = cart.saved_for_later_items
    assert_equal( 1, sfl_items.size )

    # Now remove that item while it's still in the 'Save For Later' area.
    #
    cart.cart_modify( :ASIN, @asins[0], 0 )
    items = cart.items
    assert_equal( 6, items.size )
    sfl_items = cart.saved_for_later_items
    assert_equal( 0, sfl_items.size )

    # Ensure that the item is no longer in either area of the cart.
    #
    assert( ! cart.include?( :ASIN, @add_asins[0] ) )
    assert( ! cart.active?( :ASIN, @add_asins[0] ) )
    assert( ! cart.saved_for_later?( :ASIN, @add_asins[0] ) )

    # Check that modifying non-existent item raises exception.
    #
    assert_raise( Amazon::AWS::ShoppingCart::CartError ) do
      cart.cart_modify( :ASIN, @asins[0], 1 )
    end

    # Check that retrieving the cart at a later time works properly.
    #
    old_cart = cart
    cart = Cart.new(@@key_id, @@associates_id)
    cart.locale = 'us'
    cart.cart_get( old_cart.cart_id, old_cart.hmac )
    assert_equal( old_cart.cart_id, cart.cart_id )
    assert_equal( old_cart.hmac, cart.hmac )
    assert_equal( old_cart.items, cart.items )
  end

end
