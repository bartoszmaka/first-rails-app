require 'rails_helper'

RSpec.describe Tag, type: :model do
  before(:each) do
    @tag = build(:tag)
  end

  it 'sample should be valid' do
    puts "name: #{@tag.name}"
    expect(@tag.valid?).to be true
  end

  it 'should have name' do
    @tag.name = ''
    expect(@tag.valid?).to be false
  end

  it 'should have unique name' do
    other_tag = @tag.dup
    other_tag.save
    expect(@tag.valid?).to be false
  end

  it 'should consist of alphanumeric only' do
    @tag.name = 'abc123!@#'
    expect(@tag.valid?).to be false
  end
end
