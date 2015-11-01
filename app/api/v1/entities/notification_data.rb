module V1::Entities
  class NotificationData < Grape::Entity
    expose :id, documentation: { type: "Integer", desc: "The notification id." }
    expose :is_read, documentation: { type: "boolean", desc: "The notification read status." }, as: :read
    expose :actor, documentation: { type: "UserData::AsShallow", desc: "The user that made the action." }, using: UserData::AsShallow
    expose :message, documentation: { type: "String", desc: "The message of the action to be parsed and read to the user." }
    expose :created_at, documentation: { type: "Time", desc: "The date and time the notification was created." }
    expose :notifier, documentation: { type: "[Notifier]Data::AsShallow", desc: "The notifier data." }
    expose :notifier do |notification, options|
      entity = "V1::Entities::#{notification.notifier.class}Data::AsShallow".constantize
      entity.represent(notification.notifier).as_json
    end
  end
end
