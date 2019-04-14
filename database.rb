require 'singleton'

class Database
  include Singleton

  attr_accessor :names, :counts

  def initialize
    @names = Hash.new()
    @counts = Hash.new(0)
  end

  def set(key, value)
    @names[key] = value
    @counts[value] += 1
  end

  def get(key)
    value = @names.fetch(key, "NULL")
    return value
  end

  def count(value)
    count = @counts.fetch(value, 0)
    return count
  end

  def delete(key)
    value = @names[key]
    if value
      @names.delete(key)
      @counts[value] -= 1
    else
      print("That key isn't in the database!")
    end
  end
end
