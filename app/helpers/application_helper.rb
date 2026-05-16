module ApplicationHelper
  def model_instance
    controller.instance_variables
              .map { |v| controller.instance_variable_get(v) }
              .find { |obj| obj.respond_to?(:errors) && obj.errors&.any? }
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

  def google_svg
    svg = <<~SVG
      <svg class="w-6 h-6 shrink-0" viewBox="0 0 24 24">
        <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
        <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
        <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z"/>
        <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 6.23l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
      </svg>
    SVG

    svg.html_safe
  end
end
