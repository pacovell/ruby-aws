#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../test_helper'
require 'fileutils'
require 'tmpdir'
require 'amazon/locale'

class TestAWSBasics < Test::Unit::TestCase

  CACHE_DIR = Amazon::AWS::Cache::DEFAULT_CACHE_DIR
  CACHE_PATH = File.join( Dir.tmpdir, 'aws_cache' )

  def setup
    @rg = ResponseGroup.new( :Small )
    @req = Request.new(@@key_id, @@associates_id)
    @req.locale = 'uk'
    @req.cache = false
  end

  def test_version
    v = '1.8.6'
    assert( RUBY_VERSION >= v, "Ruby version is lower than #{v}." )
  end

  def test_cache

    # Assure we can create a cache with a non-default path.
    #
    c = Cache.new( CACHE_PATH )
    assert( CACHE_PATH, c.path )
    assert( File.directory?( c.path ) )
    FileUtils.rmdir( c.path )

    c = Cache.new

    # Ensure that default cache path has been chosen.
    #
    assert( CACHE_DIR, c.path )

    # Ensure that cache directory has been created.
    #
    assert( File.directory?( c.path ) )

    f = File.join( c.path, 'foobar' )

    # Just over a day ago.
    #
    t = Time.now - 86460

    FileUtils.touch f, { :mtime => t }
    assert( File.exist?( f ) )

    # Ensure expired file is properly flushed.
    #
    c.flush_expired
    assert( ! File.exist?( f ) )

    FileUtils.touch f
    assert( File.exist?( f ) )

    # Ensure unexpired file is properly retained.
    #
    c.flush_expired
    assert( File.exist?( f ) )

    # Ensure file is properly flushed.
    #
    c.flush_all
    assert( ! File.exist?( f ) )

    h = Help.new( :ResponseGroup, :Large )
    h_rg = ResponseGroup.new( :Help )

    # Ensure that file is not cached when no cache is desired.
    #
    @req.cache = false
    resp = @req.search( h, h_rg )
    assert_equal( 0, Dir.glob( File.join( c.path, '*' ) ).size )

    # Ensure that file is cached when cache is desired.
    #
    @req.cache = c
    resp = @req.search( h, h_rg )
    assert_equal( 1, Dir.glob( File.join( c.path, '*' ) ).size )

    # Flush it away.
    #
    c.flush_all
    assert_equal( 0, Dir.glob( File.join( c.path, '*' ) ).size )

    FileUtils.rmdir( c.path )

    # Turn off caching for future tests. This happens in the setup method,
    # anyway, but it can't hurt to tidy up after ourselves.
    #
    @req.cache = false

  end

  def test_config
    # Test bad quoting.
    #
    assert_raise( Amazon::Config::ConfigError ) do
      cf = Amazon::Config.new( <<'      EOF' )
      bad_syntax = 'bad quotes"
      EOF
    end

    # Test good quoting.
    #
    assert_nothing_raised do
      cf = Amazon::Config.new( <<'      EOF' )
      good_syntax = 'good quotes'
      EOF
    end

    # Test that config files are properly read from $AMAZONRC.
    #
    Dir.mktmpdir do |td|
      ENV['AMAZONRCDIR'] = td
      ENV['AMAZONRCFILE'] = '.user_defined_name'
      File.open( File.join( td, '.user_defined_name' ), 'w' ) do |tf|
        tf.puts( 'foo = bar' )
      end

      cf = Amazon::Config.new
      assert_equal( 'bar', cf['foo'] )
      ENV['AMAZONRCDIR'] = nil
      ENV['AMAZONRCFILE'] = nil
    end
  end

  def test_exceptions
    assert_raise( Amazon::AWS::HTTPError ) { raise Amazon::AWS::HTTPError }
  end

end
