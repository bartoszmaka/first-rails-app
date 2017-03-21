require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'user associations and validations' do
    let(:user) { build(:user, password: nil) }
    subject { user }
    it { should have_many(:articles) }
    it { should have_many(:comments) }
    it { should have_many(:votes) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should_not allow_value('        ').for(:password) }
    it { should_not allow_value('        ').for(:email) }
  end

  describe 'user fatory' do
    context 'user' do
      let(:user) { build(:user) }
      it { expect(user).to be_valid }
    end

    context 'admin' do
      let(:user) { create(:admin) }
      it { expect(user).to be_valid }
      it { expect(user.roles.pluck(:name)).to eq(['admin']) }
    end

    context 'user_with_avatar' do
      let(:user) { build(:user_with_avatar) }
      it { expect(user).to be_valid }
      it { expect(user.avatar).not_to be nil }
    end
  end

  describe 'articles count counter cache' do
    let!(:user) { create(:user) }
    let!(:article) { create(:article, user: user) }
    let!(:old_articles_count) { user.articles_count }
    it 'increases by 1 after creating article' do
      create(:article, user: user)
      expect(user.articles_count).to eq(old_articles_count + 1)
    end
    it 'decreases by 1 after destroying article' do
      article.destroy
      expect(user.articles_count).to eq(old_articles_count - 1)
    end
  end

  describe 'comments count counter cache' do
    let!(:user) { create(:user) }
    let!(:comment) { create(:comment, user: user) }
    let!(:old_comments_count) { user.comments_count }
    it 'increases by 1 after creating comment' do
      create(:comment, user: user)
      expect(user.comments_count).to eq(old_comments_count + 1)
    end
    it 'decreases by 1 after destroying comment' do
      comment.destroy
      expect(user.comments_count).to eq(old_comments_count - 1)
    end
  end

  describe 'user roles management' do
    let(:user) { create(:user) }
    context '#add_role' do
      it 'adds role' do
        user.add_role('tester')
        expect(user.roles.pluck(:name).count).to eq(1)
      end
    end

    context '#role?' do
      it 'tells if user has given role' do
        user.ban
        expect(user.role?('banned')).to(be true)
      end
    end

    context '#remove_role' do
      it 'deletes given role if it exists' do
        user.ban
        user.remove_role('banned')
        expect(user.roles).to eq []
      end
    end

    context '#ban' do
      it 'adds banned role to user' do
        user.ban
        expect(user.roles).to eq [Role.find_by(name: 'banned')]
      end
    end

    context '#unban' do
      it 'removes banned role from user if it exists' do
        user.add_role('banned')
        user.unban
        expect(user.roles).to eq []
      end
    end

    context '#admin?' do
      it 'tells if user is an admin' do
        user.add_role('admin')
        expect(user.admin?).to be true
      end
    end

    context '#banned?' do
      it 'tells if user is banned' do
        user.add_role('admin')
        user.ban
        expect(user.banned?).to be true
      end
    end
  end

  describe 'admin factory' do
    let(:admin) { create(:admin) }
    it { expect(admin.admin?).to be true }
  end
end
