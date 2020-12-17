class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :update, :destroy, to: :crud
    can :read, :all # permissions for every user, even if not logged in
    cannot :read, Notification
    cannot :read, Message
    can :crud, User if user.has_role? :admin # additional permissions for administrators

    return unless user.present? # additional permissions for logged in users (they can manage their posts)

    can :manage, Comment, user_id: user.id
    can :manage, Micropost, user_id: user.id
    can :manage, Notification, user_id: user.id
    can :manage, Reaction, reactor_id: user.id
    can :manage, Relationship, follower_id: user.id
    can :manage, Message, user_id: user.id
    can :read, Message do |m|
      m.conversation.receiver = user
    end
    can :manage, Conversation, sender_id: user.id
  end
end
