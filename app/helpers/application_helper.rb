module ApplicationHelper
  def model_instance
    controller.instance_variables
              .map { |v| controller.instance_variable_get(v) }
              .find { |obj| obj.respond_to?(:errors) && obj.errors&.any? }
  end

  def plural_count(count, singular, plural)
    if count % 10 == 1 && count % 100 != 11
      "#{count} #{singular}"
    else
      "#{count} #{plural}"
    end
  end

  def nav_link_to(label, path)
    is_active = current_page?(path)

    # Define styles for reuse
    label_classes = [
      'text-[9px] font-black uppercase tracking-[0.2em] transition-colors',
      is_active ? 'text-emerald-400' : 'text-white/30 group-hover:text-white'
    ].join(' ')

    link_to path, class: 'flex flex-col items-center gap-1.5 group' do
      concat content_tag(:span, label, class: label_classes)
      if is_active
        concat content_tag(:div, nil,
                           class: 'w-1 h-1 rounded-full bg-emerald-400 shadow-[0_0_8px_rgba(52,211,153,0.6)]')
      end
    end
  end
end
