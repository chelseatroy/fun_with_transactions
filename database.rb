class Database
  def initialize
    @count_versions = [Hash.new(0)]
    @db_versions = [Hash.new()]
    @deletion_keys = [[]]
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
      @deletion_keys[@tier].push(key)
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
    @deletion_keys.push([])
    @tier += 1

    return nil
  end

  def rollback()
    if @tier == 0
      return "No transaction in progress"
    end
    
    @db_versions.pop
    @count_versions.pop
    @deletion_keys.pop

    @tier -= 1

    return nil
  end

  def commit()
    if @tier == 0
      return "No transaction in progress"
    end

    @db_versions[-2] = merge_candidate(@tier, @tier-1, @db_versions[0])
    @deletion_keys[-1].each{|key| @db_versions[-2].delete(key)}

    @count_versions[-2] = count_candidate(@tier, @tier-1, @count_versions[0])
    @db_versions.pop
    @count_versions.pop
    @deletion_keys.pop

    @tier -= 1

    return nil
  end

  #END THE CONSOLE SESSION

  def end
    exit()
  end

  private

  def merge_candidate(start_tier=@tier, end_tier=0, merge_item=@db_versions[end_tier])
    if start_tier == end_tier
      @deletion_keys[-1].each{|key| merge_item.delete(key)} if @deletion_keys[-1]
      return merge_item
    else
      step = @db_versions[start_tier].merge(merge_item) { |key, canonical_value, transactional_value|
        transactional_value || canonical_value
      }
      return merge_candidate start_tier-1, end_tier,step
    end
  end

  def count_candidate(start_tier=@tier, end_tier=0, merge_item=@count_versions[0])
    if start_tier == end_tier
      return merge_item
    else
      step = @count_versions[start_tier].merge(merge_item) { |key, canonical_value, transactional_value|
        canonical_value + transactional_value
      }
      return count_candidate start_tier-1, end_tier,step
    end
  end

end
