module ApplicationHelper
  def make_side_bar
    content_tag(:ul, class: "serverad-sidebar-menu", id: "sider") do
      yield
    end
  end

  def make_side_bar_link(text, relativePath, iconCls, sensitive=false, actions=[])
    if sensitive
      active = current_page?(URI.parse(relativePath).path)
    else
      active = relativePath.include?(controller.controller_name)
      # check allow actions
      if active && actions.any?
        active = actions.include?(controller.action_name.to_sym)
      end
    end

    options = active ? { class: 'active' } : {}
    content_tag(:li, options) do
      link_to(relativePath) do
        concat content_tag(:i, '', class: iconCls)
        concat text
      end
    end
  end

  def delete_link(link, message, icon=false, tooltip='')
    options = {
      data: {
        link: link,
        message: message
      },
      class: 'btn btn-danger delete-link'
    }
    unless tooltip.empty?
      options[:title] = tooltip
      options[:class] += ' has-tooltip'
      options[:data][:toggle] = 'tooltip'
      options[:data][:placement] = 'top'
    end
    link_to("#confirmModal", options) do
      if icon
        content_tag(:span, '', class: 'fa fa-trash-o')
      else
        concat I18n.t('helpers.links.delete')
      end
    end
  end

  def update_link(text, message)
    options = {
      data: {
        message: message
      },
      class: 'btn btn-primary update-link'
    }
    link_to("#confirmModal", options) do
      concat text
    end
  end

  def page_title
    title = t("#{controller_name}.titles.#{action_name}", default: '')
    "#{title}"
  end

  def page_sub_title
    sub_title = t("#{controller_name}.sub_titles.#{action_name}", default: '')
    "#{sub_title}"
  end

  def client_permit?
    current_user ? current_user.client? : false
  end

  def system_permit?
    current_user ? current_user.system? : false
  end

  def admin_permit?
    current_user ? current_user.admin? : false
  end
end
