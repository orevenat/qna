# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }
  it { should validate_presence_of(:value) }
  it { should validate_inclusion_of(:value).in_array([-1, 0, 1]) }
  # it { should validate_uniqueness_of(:user_id).scoped_to(:votable_id, :votable_type) }
end
