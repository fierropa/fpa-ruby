module ApplicationHelper
  def current_user_email
    fa_icon("user").concat(content_tag(:span, current_user.try(:email), class: 'hidden-sm-down'))    
  end
end
