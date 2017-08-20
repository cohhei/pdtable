$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "pdtable"

require "minitest/autorun"

def check_types(arr, type)
  result = true
  arr.each do |v|
    next if v.class == type || v.nil?

    # When there is a invalid class in arr -> return false
    result = false
    break
  end
  result
end