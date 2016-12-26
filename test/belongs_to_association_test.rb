# -*- encoding : utf-8 -*-
require 'test_helper'

class BelongsToAssociationTest < ActiveSupport::TestCase
  def setup
    @user = User.create :name => 'csdn', :email => 'test@csdn.com'
  end

  def test_should_get_cache_when_use_belongs_to_association
    book = @user.books.create

    @user.write_second_level_cache
    book.clear_association_cache
    assert_no_queries do
      assert_equal @user, book.user
    end
  end

  def test_should_write_belongs_to_association_cache
    book = @user.books.create
    @user.expire_second_level_cache
    assert_nil User.read_second_level_cache(@user.id)
    assert_equal @user, book.user
    # assert_not_nil User.read_second_level_cache(@user.id)
  end

  def test_has_many_with_scope
    @user.books.create(read: false)
    favorite_book = @user.books.create(read: true)
    assert_equal @user.favorite_book, favorite_book
    assert_equal User.find(@user.id).favorite_book, favorite_book
  end
end
