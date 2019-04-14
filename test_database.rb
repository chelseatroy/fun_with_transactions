require_relative "database"
require "test/unit"

class TestSimpleNumber < Test::Unit::TestCase

  def test_get_set_happy_path  #These two methods are tested together because isolating them would require opening direct access to database objects.
    db = Database.instance

    db.set "Crested", "Cardinal"
    assert_equal("Cardinal", db.get("Crested"))
  end

  def test_get_no_value
    db = Database.instance

    assert_equal("NULL", db.get("NoKey"))
  end

  def test_count_happy_path
    db = Database.instance

    db.set "Snowy", "Owl"
    assert_equal(1, db.count("Owl"))
    db.set "GreatHorned", "Owl"
    assert_equal(2, db.count("Owl"))
  end

  def test_count_no_value
    db = Database.instance

    assert_equal(0, db.count("NoKey"))
  end

  def test_delete_happy_path
    db = Database.instance

    db.set "Tufted", "Titmouse"
    assert_equal("Titmouse", db.get("Tufted"))

    db.delete "Tufted"
    assert_equal("NULL", db.get("Tufted"))
  end

  def test_delete_absent_key
    db = Database.instance

    assert_equal("That key isn't in the database!", db.delete("NoKey"))
  end

  def test_commit_with_transaction
    db = Database.instance

    db.set "BlueAndGold", "Maccaw"
    assert_equal(1, db.count("Maccaw"))

    db.begin
    db.set "GreenWing", "Maccaw"
    db.commit

    assert_equal(2, db.count("Maccaw"))
    assert_equal("Maccaw" , db.get("GreenWing"))
  end

  def test_commit_no_transaction
    db = Database.instance

    assert_equal("No transaction in progress", db.commit)
  end

  def test_rollback_with_transaction
    db = Database.instance

    db.set "Bald", "Eagle"
    assert_equal(1, db.count("Eagle"))

    db.begin
    db.set "Golden", "Eagle"
    db.rollback

    assert_equal(1, db.count("Eagle"))
    assert_equal("NULL" , db.get("Golden"))
  end

  def test_rollback_no_transaction
    db = Database.instance

    assert_equal("No transaction in progress", db.rollback)
  end

  def test_nested_transaction
    db = Database.instance

    db.set "Pacific", "Baza"
    assert_equal(1, db.count("Baza"))

    db.begin
    db.set "Black", "Baza"

    assert_equal(2, db.count("Baza"))
    assert_equal("Baza", db.get("Black"))

    db.begin
    db.set "Jerdons", "Baza"

    assert_equal(3, db.count("Baza"))
    assert_equal("Baza", db.get("Jerdons"))

    db.rollback

    assert_equal(2, db.count("Baza"))
    assert_equal("Baza", db.get("Black"))
    assert_equal("Baza" , db.get("Pacific"))

    db.commit

    assert_equal(2, db.count("Baza"))
    assert_equal("Baza" , db.get("Pacific"))
    assert_equal("Baza" , db.get("Black"))
    assert_equal("NULL" , db.get("Jerdons"))
  end
end