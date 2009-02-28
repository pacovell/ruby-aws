# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-aws}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["hollownest"]
  s.date = %q{2009-02-28}
  s.description = %q{TODO}
  s.email = %q{pac@hollownest.com}
  s.files = ["README.rdoc", "lib/amazon", "lib/amazon/aws", "lib/amazon/aws/cache.rb", "lib/amazon/aws/search.rb", "lib/amazon/aws/shoppingcart.rb", "lib/amazon/aws.rb", "lib/amazon/locale.rb", "lib/amazon.rb", "test/local", "test/local/cache_files", "test/local/cache_files/books.xml", "test/local/cache_files/electronics.xml", "test/local/cache_files/movies.xml", "test/local/cache_files/music.xml", "test/local/tc_local_search.rb", "test/network", "test/network/tc_amazon.rb", "test/network/tc_aws.rb", "test/network/tc_item_search.rb", "test/network/tc_multiple_operation.rb", "test/network/tc_operation_request.rb", "test/network/tc_serialisation.rb", "test/network/tc_shopping_cart.rb", "test/network/tc_vehicle_operations.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/hollownest/ruby-aws}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
