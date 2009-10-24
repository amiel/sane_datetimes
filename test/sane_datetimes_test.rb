require 'rubygems'
require 'test/unit'
require 'shoulda'

require 'active_support'
require 'active_record'

require "#{File.dirname(__FILE__)}/../init"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
	ActiveRecord::Migration.verbose = false
	ActiveRecord::Schema.define(:version => 1) do
		create_table :sane_datetimes_test_models do |t|
			t.column :created_at, :datetime      
			t.column :updated_at, :datetime

			t.column :test_on, :date
			t.column :test_at, :datetime
		end
	end
end

def teardown_db
	ActiveRecord::Base.connection.tables.each do |table|
		ActiveRecord::Base.connection.drop_table(table)
	end
end


class SaneDatetimesTestModel < ActiveRecord::Base; end




class SaneDatetimesTest < Test::Unit::TestCase # ActiveSupport::TestCase
	def setup
		setup_db
		@test = SaneDatetimesTestModel.new
	end

	def teardown
		teardown_db
	end


	should 'be able set a normal multi-param time' do
		@test.attributes = { :'test_at(1i)' => '2009', :'test_at(2i)' => '12', :'test_at(3i)' => '31', :'test_at(4i)' => '5', :'test_at(5i)' => '30' }
		assert_equal Time.local(2009, 12, 31, 5, 30), @test.test_at
	end
	
	should 'be able set a normal multi-param time with just a date' do
		@test.attributes = { :'test_at(1i)' => '2009', :'test_at(2i)' => '12', :'test_at(3i)' => '31' }
		assert_equal Time.local(2009, 12, 31), @test.test_at
	end

	should 'be able set a normal multi-param date' do
		@test.attributes = { :'test_on(1i)' => '2009', :'test_on(2i)' => '12', :'test_on(3i)' => '31' }
		assert_equal Time.local(2009, 12, 31).to_date, @test.test_on
	end
	
	should 'be able to set a multi-param time with date and time strings' do
		@test.attributes = { :'test_at(1s)' => '12/31/2009', :'test_at(2s)' => '5:30' }
		assert_equal Time.local(2009, 12, 31, 5, 30), @test.test_at
	end

	should 'be able to set a multi-param time with just a date string' do
		@test.attributes = { :'test_at(1s)' => '12/31/2009' }
		assert_equal Time.local(2009, 12, 31), @test.test_at
	end

	
	should 'be able to set a multi-param time with date and time strings when date is hand-written' do
		@test.attributes = { :'test_at(1s)' => 'Oct 5, 2009', :'test_at(2s)' => '5:30' }
		assert_equal Time.local(2009, 10, 5, 5, 30), @test.test_at
	end
	
	should 'add an error if out of range' do
		@test.attributes = { :'test_at(1s)' => '3 10 33' } # random string that raises ArgumentError
		assert @test.errors.on(:test_at)
	end
	
	should 'be able to set an empty datetime' do
		@test.attributes = { :'test_at(1s)' => '', :'test_at(2s)' => '' }
		assert_equal nil, @test.test_at
	end
end

