require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = User.new(
      name: 'Example User',
      email: 'exampleemail@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  it 'should be valid' do
    expect(@user.valid?).to be true
  end

  it 'should require name' do
    @user.name = '    '
    expect(@user.valid?).to be false
  end

  it 'should require email' do
    @user.email = '    '
    expect(@user.valid?).to be false
  end

  it 'should not have too long name' do
    @user.name = 'a' * 51
    expect(@user.valid?).to be false
  end

  it 'should not have too long email' do
    @user.email = 'a' * 244 + '@example.com'
    expect(@user.valid?).to be false
  end

  it 'should accept valid email' do
    valid_emails = %w(
      user@example.com USER@foo.COM A_US-ER@foo.bar.org
      forst.last@foo.jp alice+bob@baz.cn
    )
    valid_emails.each do |valid_email|
      @user.email = valid_email
      expect(@user.valid?).to be true
    end
  end

  it 'should be unique' do
    duplicated = @user.dup
    duplicated.email = @user.email.upcase
    @user.save
    expect(duplicated.valid?).to be false
  end

  it 'should have nonblank password' do
    @user.password = @user.password_confirmation = ' ' * 6
    expect(@user.valid?).to be false
  end

  it 'should have long enough password' do
    @user.password = @user.password_confirmation = 'a' * 4
    expect(@user.valid?).to be false
  end
end
