require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards) }
  it { should have_many(:comments) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'user is autor_of?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'user is author of question' do
      expect(user).to be_author_of(question)
    end

    it 'user is not author of question' do
      expect(another_user).to_not be_author_of(question)
    end
  end
end
