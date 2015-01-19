module MessagesHelper
  # find a single conversation given a list of recipients
  # or nil if no such conversation exists
  def conv_from_recipients(recipients)
    # make sure the list contains only users
    unless recipients.all? { |u| u.class == User }
      nil
    else
      # sort the recipients
      recipients.sort!
      # get the first recipient's conversations
      convs = recipients[0].mailbox.conversations
      # return the first conversation that has all recipients
      convs.select { |c| c.recipients.sort == recipients }[0]
    end
  end

  # get the conversations for a user in a
  # form that works for the front end
  def json_conversations(user)
    unless user.class == User
      nil
    else
      convs = user.mailbox.conversations.all
      json_convs = []
      convs.each do |c|
        conv = {}
        participants = c.recipients
        participants.delete user
        participants.map! { |u| u.name }
        conv['participants'] = participants
        conv['id'] = c.id
        json_convs.push conv
      end
      json_convs
    end
  end

  # gets a specific conversation for a user
  def user_conversation(user, conv_id)
    msg = user.mailbox.conversations.find(conv_id)
    receipts = msg.receipts_for user
    messages = []
    receipts.each do |m|
      messages.push Hash["message" => m.message, "sender" => m.message.sender.name]
    end
    messages.reverse
  end
end
