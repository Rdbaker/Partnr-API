module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    puts resource.errors
    messages = resource.errors.full_messages
    sentence = I18n.t("errors.messages.not_saved",
                count: resource.errors.count,
                resource: resource.class.model_name.human.downcase)

    {
      sentence => messages
    }.to_json
  end
end
