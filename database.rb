require 'singleton'

class Database
  include Singleton

  attr_accessor :names, :count_versions

  def initialize
    @count_versions = [Hash.new(0)]
    @db_versions = [Hash.new()]
  end

  # CRUD COMMANDS
  def set(key, value)
    @db_versions[-1][key] = value
    @count_versions[-1][value] += 1
  end

  def get(key)
    value = @db_versions[-1].fetch(key, "NULL")
    return value
  end

  def count(value)
    count = @count_versions[-1].fetch(value, 0)
    return count
  end

  def delete(key)
    value = @db_versions[-1][key]
    if value
      @db_versions[-1].delete(key)
      @count_versions[-1][value] -= 1
    else
      print("That key isn't in the database!")
    end
  end

  #TRANSACTION MANAGEMENT
  def begin()
    @db_versions.push(Hash.new(0))
    @count_versions.push(Hash.new(0))
  end

  def rollback()
    @db_versions.pop
    @count_versions.pop
  end
  
end
