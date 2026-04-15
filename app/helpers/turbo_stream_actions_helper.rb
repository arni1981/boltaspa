module TurboStreamActionsHelper
  def toast(content, type)
    turbo_stream_action_tag :toast, content: content, type: type
  end

  def show_modal(target:)
    turbo_stream_action_tag :show_modal, target: target
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamActionsHelper)
