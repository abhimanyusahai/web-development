require 'test_helper'

class TeacherTest < ActiveSupport::TestCase
  def setup
    @teacher = Teacher.new(first_name: "Example", last_name: "Teacher", email_id: "example@teacher.com", 
      mobile_number: "+919999900000", admin: false, password: "password", password_confirmation: "password")
  end
  
  test "should be valid" do
    assert @teacher.valid?
  end
  
  test "first name should be present" do
    @teacher.first_name = "   "
    assert_not @teacher.valid?
  end
  
  test "first name should not be too long" do
    @teacher.first_name = 'a'*51
    assert_not @teacher.valid?
  end
  
  test "last name should not be too long" do
    @teacher.last_name = 'a'*51
    assert_not @teacher.valid?
  end
  
  test "email should not be too long" do
    @teacher.email_id = 'a'*244 + '@example.com'
    assert_not @teacher.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @teacher.email_id = valid_address
      assert @teacher.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @teacher.email_id = invalid_address
      assert_not @teacher.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_teacher = @teacher.dup
    duplicate_teacher.email_id = @teacher.email_id.upcase
    @teacher.save
    assert_not duplicate_teacher.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @teacher.email_id = mixed_case_email
    @teacher.save
    assert_equal mixed_case_email.downcase, @teacher.reload.email_id
  end
  
  test "password should be non blank" do
    @teacher.password = @teacher.password_confirmation = " "*5
    assert_not @teacher.valid?
  end
  
  test "password should have minimum length" do
    @teacher.password = @teacher.password_confirmation = "a"*5
    assert_not @teacher.valid?
  end
end
