require 'rails_helper'

RSpec.describe Reaction, type: :model do
  let(:user_mike) { create(:user_mike) }
  let(:micropost) { user_mike.microposts.create(content: 'Lorem ipsum') }
  let(:comment) { micropost.comments.create(user_id: user_mike.id, content: 'test content') }
  let(:reaction) do
    micropost.reactions.build(reactor_id: user_mike.id,
                              react_to_id: micropost.id,
                              react_to_type: micropost.class.name,
                              icon_id: 1)
  end

  it 'should valid' do
    expect(reaction.valid?).to eq(true)
  end

  it 'should invalid' do
    reaction.reactor_id = nil
    expect(reaction.valid?).to eq(false)
  end

  it 'should invalid with null react_to' do
    reaction.react_to_id = nil
    expect(reaction.valid?).to eq(false)
  end

  it 'should invalid if icon_id out of range' do
    reaction.icon_id = 10
    expect(reaction.valid?).to eq(false)
  end
end
