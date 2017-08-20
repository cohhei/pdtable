require "pdtable/version"
require 'csv'

module Pdtable
  class Pdtable < CSV::Table
    def initialize(path, dtype: nil, skiprows: nil)
      @table = CSV.table path
      @mode = :col_or_row
      delete_rows(@table, skiprows) unless skiprows.nil?
      @dtype = inspect_data_types(@table)
      @dtype.merge!(dtype) unless dtype.nil?
      convert(@table, @dtype)
    end

    attr_reader :table, :dtype

    def set_mode!(mode, t = self)
      if mode == :row
        t.by_row!
      elsif mode == :column
        t.by_col!
      elsif mode == :col_or_row
        t.by_col_or_row!
      end
    end

    def delete(index_or_header)
      @table.delete index_or_header
    end

    private

    # return type of columns as array
    def inspect_data_types(t)
      types = {}

      t.headers.each do |col|
        type = NilClass
        t[col].each do |v|
          next if v.nil?
          if v.class == String
            type = type_of(v)
          else
            type = v.class
          end
          break
        end
        types[col] = type
      end

      types
    end
    
    def type_of(str)
      type = str.class
      begin
        dt = DateTime.parse str
        type = dt.class
      rescue => exception
      end
      type
    end

    # Convert each column's values.
    # This function destructive for `t`.
    def convert(t, dtype)
      dtype.each do |col, type|
        if type == Integer 
          t[col] = t[col].map{|v| v.to_i unless v.nil?}
        elsif type == Float
          t[col] = t[col].map{|v| v.to_f unless v.nil?}
        elsif type == String
          t[col] = t[col].map{|v| v.to_s unless v.nil?}
        elsif type == DateTime
          t[col] = t[col].map do |dt|
            begin
              DateTime.parse dt.to_s
            rescue => exception
            end
          end
        elsif type == Date
          t[col] = t[col].map do |dt|
            begin
              Date.parse dt.to_s
            rescue => exception
            end
          end
        else
          throw "Unsupported dtype '#{type}'"
        end
      end
    end

    # Delete rows from `t`.
    # This function destructive for `t`.
    def delete_rows(t, rows)
      case rows
      when Integer
        t.delete rows
      when Array
        mode = t.mode
        t.by_row!

        will_delete = rows.map{|n| t[n]}
        t.delete_if do |row|
          will_delete.find do |del_row|
            del_row == row
          end
        end

        set_mode!(mode, t)
      else
        throw "Unsupported type '#{rows.class}' in skiprows."
      end
    end
  end
end

