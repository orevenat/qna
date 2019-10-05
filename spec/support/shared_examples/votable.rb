# frozen_string_literal: true

RSpec.shared_examples 'votable' do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  context 'user can' do
    it 'vote up' do
      expect { resource.vote_up(user) }.to change(resource, :rating).from(0).to(1)
    end

    it 'vote down' do
      expect { resource.vote_down(user) }.to change(resource, :rating).from(0).to(-1)
    end

    it 'cancel his vote and vote again' do
      resource.vote_down(user)
      expect(resource.user_already_voted?(user)).to eq(true)
      resource.vote_cancel(user)
      expect(resource.user_already_voted?(user)).to eq(false)
    end

    it 'counting raiting' do
      expect { resource.vote_up(user) }.to change(resource, :rating).from(0).to(1)
      expect { resource.vote_up(another_user) }.to change(resource, :rating).from(1).to(2)
      expect { resource.vote_cancel(user) }.to change(resource, :rating).from(2).to(1)
      expect { resource.vote_down(user) }.to change(resource, :rating).from(1).to(0)
    end
  end
end
