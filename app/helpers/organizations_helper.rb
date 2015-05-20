module OrganizationsHelper

  def logo_for(organization, options = { size: '80' })
    image_tag(organization.logo_url, alt: organization.name, size: options[:size], class: "gravatar")
  end

end
