require 'singleton'

class Database
  include Singleton

  def initialize
    @count_versions = [Hash.new(0)]
    @db_versions = [Hash.new()]
    @tier = 0
  end

  # CRUD COMMANDS

  def set(key, value)
    @db_versions[@tier][key] = value
    @count_versions[@tier][value] += 1
    return nil
  end

  def get(key)
    merge_candidate.fetch(key, "NULL")
  end

  def count(value)
    count_candidate.fetch(value, 0)
  end

  def delete(key)
    value = merge_candidate[key]
    if value
      @db_versions[@tier].delete(key)
      @count_versions[@tier][value] -= 1
      return nil
    else
      return "That key isn't in the database!"
    end
  end

  #TRANSACTION MANAGEMENT

  def begin()
    @db_versions.push(Hash.new())
    @count_versions.push(Hash.new(0))
    @tier += 1
    return nil
  end

  def rollback()
    if @tier == 0
      return "No transaction in progress"
    end
    
    @db_versions.pop
    @count_versions.pop
    @tier -= 1
    return nil
  end

  def commit()
    if @tier == 0
      return "No transaction in progress"
    end

    @db_versions[-2] = merge_candidate()
    @count_versions[-2] = count_candidate()
    @db_versions.pop
    @count_versions.pop

    @tier -= 1
    return nil
  end

  def merge_candidate(tier=@tier, merge_item=@db_versions[0])
    if tier == 0
      return merge_item
    else
      step = @db_versions[tier].merge(merge_item) { |key, canonical_value, transactional_value|
        transactional_value || canonical_value
      }
      return merge_candidate tier-1, step
    end
  end

  def count_candidate(tier=@tier, merge_item=@count_versions[0])
    if tier == 0
      return merge_item
    else
      step = @count_versions[tier].merge(merge_item) { |key, canonical_value, transactional_value|
        canonical_value + transactional_value
      }
      return count_candidate tier-1, step
    end
  end

  #END THE CONSOLE SESSION

  def end
    exit()
  end
end
