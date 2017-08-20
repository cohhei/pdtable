require 'pdtable'
require 'minitest'
require 'csv'
require "test_helper"
MiniTest::Unit.autorun

class PdtableTest < Minitest::Test
  def setup
    @default_path = 'test/csv/default.csv'
    @invalid_path = 'invalid/path/to/csv'
    @default_csv = Pdtable::Pdtable.new @default_path
  end

  def test_that_it_has_a_version_number
    refute_nil ::Pdtable::VERSION
  end

  def test_it_returns_a_csv_table
    assert_equal @default_csv.class, Pdtable::Pdtable
  end

  def test_it_returns_error_when_invalid_path
    e = assert_raises Errno::ENOENT do
      t = Pdtable::Pdtable.new @invalid_path
    end
    assert_equal "No such file or directory @ rb_sysopen - #{@invalid_path}", e.message
  end

  def test_type_of_columns
    assert check_types(@default_csv[:date], DateTime)
    assert check_types(@default_csv[:datetime], DateTime)
    assert check_types(@default_csv[:integer], Integer)
    assert check_types(@default_csv[:float], Float)
    assert check_types(@default_csv[:string], String)
  end

  def test_correct_dtype
    dtype = {date: DateTime, datetime: DateTime, integer: Integer, float: Float, string: String}
    assert_equal @default_csv.dtype, dtype
  end

  def test_specified_dtype
    dtype = {date: Date, datetime: String, integer: Float, float: String, string: String}
    c = Pdtable::Pdtable.new @default_path, dtype: dtype
    assert check_types(c[:date], Date)
    assert check_types(c[:datetime], String)
    assert check_types(c[:integer], Float)
    assert check_types(c[:float], String)
    assert check_types(c[:string], String)
  end

  def test_skip_rows
    del0  = Pdtable::Pdtable.new @default_path, skiprows: 0
    del12 = Pdtable::Pdtable.new @default_path, skiprows: [1, 2]

    c = Pdtable::Pdtable.new @default_path
    c.delete 0
    assert_equal del0, c

    c = Pdtable::Pdtable.new @default_path
    c.delete 1
    c.delete 1
    assert_equal del12, c
  end
end
