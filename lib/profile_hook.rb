class ProfileHook  < Redmine::Hook::ViewListener

    def view_layouts_base_html_head(context = {})
        stylesheet_link_tag('profile', :plugin => 'extended_profile')
    end

    render_on :view_account_register,          :partial => 'profile/register'
    render_on :view_my_account,                :partial => 'profile/account'
    render_on :view_users_form,                :partial => 'profile/edit'
    render_on :view_account_left_bottom,       :partial => 'profile/view'
    render_on :view_sidebar_author_box_bottom, :partial => 'profile/author'

end
