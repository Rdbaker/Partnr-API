module MessagesHelper
  # find a single conversation given a list of recipients
  # or nil if no such conversation exists
  def conv_from_recipients(recipients)
    # make sure the list contains only users
    unless !(recipients.empty?) && recipients.all? { |u| u.class == User }
      return nil
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
        parts = []
        participants = c.recipients
        participants.delete user
        participants.each do |p|
          parts.push({ "name"=>p.name, "email"=>p.email })
        end
        conv['participants'] = parts
        conv['id'] = c.id
        json_convs.push conv
      end
      json_convs
    end
  end

  # gets a specific conversation for a user
  def user_conversation(user, conv_id)
    if user.class != User || conv_id.class != Fixnum
      return []
    else
      msg = user.mailbox.conversations.find_by_id(conv_id)
      # if no conversation was found
      if !msg
        return []
      else
        receipts = msg.receipts_for user
        messages = []
        receipts.each do |m|
          messages.push Hash["message" => m.message, "sender" => m.message.sender.name]
        end
        messages.reverse
      end
    end
  end
end
