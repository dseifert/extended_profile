class ProfileHook  < Redmine::Hook::ViewListener

    def view_layouts_base_html_head(context = {})
        stylesheet_link_tag('profile', :plugin => 'extended_profile')
    end

    def view_account_register(context = {})
        projects = Project.all_public.active(:order => 'name')
        project_id = context[:request].params[:profile] ? context[:request].params[:profile][:project_id].to_i : nil
        profile = ''
        profile += '<p>'
        profile += label_tag('profile[project_id]', l(:label_project_of_interest) + ' ' + content_tag(:span, '*', :class => 'required'))
        profile += select_tag('profile[project_id]', options_from_collection_for_select(projects, :id, :name, project_id))
        profile += '</p>'
        return profile
    end

    def view_my_account(context = {})
        projects = Project.visible.all(:order => 'name')
        profile = ''
        profile += '<p>'
        profile += label_tag('profile[company]', l(:label_company))
        profile += text_field_tag('profile[company]', context[:user].profile[:company], :size => 30)
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[company_site]', l(:label_company_site))
        profile += text_field_tag('profile[company_site]',
            context[:user].profile[:company_site].blank? ? 'http://' : context[:user].profile[:company_site],
            :size => 30, :class => context[:user].profile[:company_site].blank? ? 'empty' : nil,
            :onfocus => "if (this.value == 'http://') { this.value = ''; this.className = ''; }")
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[position]', l(:label_position))
        profile += text_field_tag('profile[position]', context[:user].profile[:position], :size => 30)
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[project_id]', l(:label_project_of_interest) + ' ' + content_tag(:span, '*', :class => 'required'))
        profile += select_tag('profile[project_id]', options_from_collection_for_select(projects, :id, :name, context[:user].profile[:project_id]))
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[personal_site]', l(:label_personal_site))
        profile += text_field_tag('profile[personal_site]',
            context[:user].profile[:personal_site].blank? ? 'http://' : context[:user].profile[:personal_site],
            :size => 30, :class => context[:user].profile[:personal_site].blank? ? 'empty' : nil,
            :onfocus => "if (this.value == 'http://') { this.value = ''; this.className = ''; }")
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[blog]', l(:label_blog))
        profile += text_field_tag('profile[blog]',
            context[:user].profile[:blog].blank? ? 'http://' : context[:user].profile[:blog],
            :size => 30, :class => context[:user].profile[:blog].blank? ? 'empty' : nil,
            :onfocus => "if (this.value == 'http://') { this.value = ''; this.className = ''; }")
        profile += '</p>'
        profile += '<p style="padding-bottom: 0;">'
        profile += label_tag('profile[facebook]', l(:label_facebook_profile_id_or_username))
        profile += text_field_tag('profile[facebook]', context[:user].profile[:facebook], :size => 30)
        profile += '<br/>'
        profile += content_tag(:em, l(:sample_facebook_profile_id))
        profile += '</p>'
        profile += '<p style="padding-bottom: 0;">'
        profile += label_tag('profile[twitter]', l(:label_twitter_username))
        profile += text_field_tag('profile[twitter]', context[:user].profile[:twitter], :size => 30)
        profile += '<br/>'
        profile += content_tag(:em, l(:sample_twitter_username))
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[linkedin]', l(:label_linkedin))
        profile += text_field_tag('profile[linkedin]',
            context[:user].profile[:linkedin].blank? ? 'http://' : context[:user].profile[:linkedin],
            :size => 30, :class => context[:user].profile[:linkedin].blank? ? 'empty' : nil,
            :onfocus => "if (this.value == 'http://') { this.value = ''; this.className = ''; }")
        profile += '</p>'
        return profile
    end

    def view_users_form(context = {})
        projects = Project.all(:conditions => Project.visible_by(context[:user]), :order => 'name')
        profile = ''
        profile += '<p>'
        profile += label_tag('profile[company]', l(:label_company))
        profile += text_field_tag('profile[company]', context[:user].profile[:company], :size => 30)
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[company_site]', l(:label_company_site))
        profile += text_field_tag('profile[company_site]', context[:user].profile[:company_site], :size => 30)
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[position]', l(:label_position))
        profile += text_field_tag('profile[position]', context[:user].profile[:position], :size => 30)
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[project_id]', l(:label_project_of_interest) + ' ' + content_tag(:span, '*', :class => 'required'))
        profile += select_tag('profile[project_id]', options_from_collection_for_select(projects, :id, :name, context[:user].profile[:project_id]))
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[personal_site]', l(:label_personal_site))
        profile += text_field_tag('profile[personal_site]', context[:user].profile[:personal_site], :size => 30)
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[blog]', l(:label_blog))
        profile += text_field_tag('profile[blog]', context[:user].profile[:blog], :size => 30)
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[facebook]', l(:label_facebook_profile_id_or_username))
        profile += text_field_tag('profile[facebook]', context[:user].profile[:facebook], :size => 30)
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[twitter]', l(:label_twitter_username))
        profile += text_field_tag('profile[twitter]', context[:user].profile[:twitter], :size => 30)
        profile += '</p>'
        profile += '<p>'
        profile += label_tag('profile[linkedin]', l(:label_linkedin))
        profile += text_field_tag('profile[linkedin]', context[:user].profile[:linkedin], :size => 30)
        profile += '</p>'
        return profile
    end

    def view_account_left_bottom(context = {})
        profile = ''
        if context[:user].profile[:company].present? ||
           context[:user].profile[:company_site].present? ||
           context[:user].profile[:position].present? ||
           context[:user].profile[:personal_site].present? ||
           context[:user].profile[:blog].present? ||
           context[:user].profile[:facebook].present? ||
           context[:user].profile[:twitter].present? ||
           context[:user].profile[:linkedin].present?
            profile += content_tag(:h3, l(:label_profile))
            profile += '<ul>'
            if context[:user].profile[:company].present?
                profile += content_tag(:li, l(:label_company) + ': ' + h(context[:user].profile[:company]))
            end
            if context[:user].profile[:company_site].present?
                profile += content_tag(:li, l(:label_company_site) + ': ' + content_tag(:a, h(context[:user].profile[:company_site]), :href => context[:user].profile[:company_site], :class => 'external'))
            end
            if context[:user].profile[:position].present?
                profile += content_tag(:li, l(:label_position) + ': ' + h(context[:user].profile[:position]))
            end
            if context[:user].profile[:personal_site].present?
                profile += content_tag(:li, l(:label_personal_site) + ': ' + content_tag(:a, h(context[:user].profile[:personal_site]), :href => context[:user].profile[:personal_site], :class => 'external'))
            end
            if context[:user].profile[:blog].present?
                profile += content_tag(:li, l(:label_blog) + ': ' + content_tag(:a, h(context[:user].profile[:blog]), :href => context[:user].profile[:blog], :class => 'external'))
            end
            if context[:user].profile[:facebook].present?
                facebook = context[:user].profile[:facebook].match(/^[0-9]+$/) ? "http://www.facebook.com/profile.php?id=#{context[:user].profile[:facebook]}" : "http://www.facebook.com/#{context[:user].profile[:facebook]}"
                profile += content_tag(:li, l(:label_facebook) + ': ' + content_tag(:a, h(facebook), :href => facebook, :class => 'external facebook'))
            end
            if context[:user].profile[:twitter].present?
                profile += content_tag(:li, l(:label_twitter) + ': ' + content_tag(:a, '@' + h(context[:user].profile[:twitter]), :href => "http://twitter.com/#{context[:user].profile[:twitter]}", :class => 'external twitter'))
            end
            if context[:user].profile[:linkedin].present?
                profile += content_tag(:li, l(:label_linkedin) + ': ' + content_tag(:a, h(context[:user].profile[:linkedin]), :href => context[:user].profile[:linkedin], :class => 'external linkedin'))
            end
            profile += '</ul>'
        end
        return profile
    end

    def view_sidebar_author_box_bottom(context = {})
        profile = ''
        if context[:user].profile[:company].present?
            if context[:user].profile[:company_site].present?
                profile += content_tag(:a, h(context[:user].profile[:company]), :href => context[:user].profile[:company_site], :class => 'company')
            else
                profile += content_tag(:p, h(context[:user].profile[:company]), :class => 'company')
            end
        end
        if context[:user].profile[:position].present?
            profile += content_tag(:p, h(context[:user].profile[:position]), :class => 'position')
        end
        social = ''
        if context[:user].profile[:facebook].present?
            facebook = context[:user].profile[:facebook].match(/^[0-9]+$/) ? "http://www.facebook.com/profile.php?id=#{context[:user].profile[:facebook]}" : "http://www.facebook.com/#{context[:user].profile[:facebook]}"
            social += content_tag(:a, image_tag('facebook.png', :plugin => 'extended_profile'), :href => facebook)
        end
        if context[:user].profile[:twitter].present?
            social += content_tag(:a, image_tag('twitter.png', :plugin => 'extended_profile', :alt => '@' + h(context[:user].profile[:twitter])), :href => "http://twitter.com/#{context[:user].profile[:twitter]}")
        end
        if context[:user].profile[:linkedin].present?
            social += content_tag(:a, image_tag('linkedin.png', :plugin => 'extended_profile'), :href => context[:user].profile[:linkedin])
        end
        unless social.blank?
            profile += content_tag(:p, social, :class => 'icons')
        end
        return profile
    end

end
