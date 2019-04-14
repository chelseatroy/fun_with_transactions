require 'singleton'

class Database
  include Singleton

  attr_accessor :names, :count_versions

  def initialize
    @count_versions = [Hash.new(0)]
    @db_versions = [Hash.new()]
    @tier = 0
  end

  # CRUD COMMANDS
  def set(key, value)
    @db_versions[@tier][key] = value
    @count_versions[@tier][value] += 1
  end

  def get(key)
    @db_versions[@tier].fetch(key, "NULL")
  end

  def count(value)
    count_candidate.fetch(value, 0)
  end

  def delete(key)
    value = @db_versions[@tier][key]
    if value
      @db_versions[@tier].delete(key)
      @count_versions[@tier][value] -= 1
    else
      print("That key isn't in the database!")
    end
  end

  #TRANSACTION MANAGEMENT
  def begin()
    @db_versions.push(Hash.new(0))
    @count_versions.push(Hash.new(0))
    @tier += 1
  end

  def rollback()
    @db_versions.pop
    @count_versions.pop
    @tier -= 1
  end

  def commit()
    @db_versions[-2] = merge_candidate()
    @count_versions[-2] = count_candidate()
    rollback()
    @tier -= 1
  end

  def merge_candidate()
    merge_backs = @tier

    if merge_backs == 0
      return @db_versions[-@tier]
    else
      return @db_versions[@tier-1].merge!(@db_versions[@tier]) {
          |key, canonical_value, transactional_value|
        transactional_value || canonical_value
      }
    end
  end

  def count_candidate()
    return @count_versions[@tier-1].merge!(@count_versions[@tier]) {
        |key, canonical_value, transactional_value| canonical_value + transactional_value
    }
  end

  def end
    exit()
  end
end
