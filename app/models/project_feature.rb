class ProjectFeature < ActiveRecord::Base
  # == Project features permissions
  #
  # Grants access level to project tools
  #
  # Tools can be enabled only for users, everyone or disabled
  # Access control is made only for non private projects
  #
  # levels:
  #
  # Disabled: not enabled for anyone
  # Private:  enabled only for team members
  # Enabled:  enabled for everyone able to access the project
  #

  # Permission levels
  DISABLED = 0
  PRIVATE  = 10
  ENABLED  = 20

  FEATURES = %i(issues merge_requests wiki snippets builds repository)

  # Default scopes force us to unscope here since a service may need to check
  # permissions for a project in pending_delete
  # http://stackoverflow.com/questions/1540645/how-to-disable-default-scope-for-a-belongs-to
  belongs_to :project, -> { unscope(where: :pending_delete) }

  validate :repository_children_level

  default_value_for :builds_access_level,         value: ENABLED, allows_nil: false
  default_value_for :issues_access_level,         value: ENABLED, allows_nil: false
  default_value_for :merge_requests_access_level, value: ENABLED, allows_nil: false
  default_value_for :snippets_access_level,       value: ENABLED, allows_nil: false
  default_value_for :wiki_access_level,           value: ENABLED, allows_nil: false
  default_value_for :repository_access_level,     value: ENABLED, allows_nil: false

  def feature_available?(feature, user)
    raise ArgumentError, 'invalid project feature' unless FEATURES.include?(feature)

    get_permission(user, public_send("#{feature}_access_level"))
  end

  def builds_enabled?
    return true unless builds_access_level

    builds_access_level > DISABLED
  end

  def wiki_enabled?
    return true unless wiki_access_level

    wiki_access_level > DISABLED
  end

  def merge_requests_enabled?
    return true unless merge_requests_access_level

    merge_requests_access_level > DISABLED
  end

  private

  # Validates builds and merge requests access level
  # which cannot be higher than repository access level
  def repository_children_level
    validator = lambda do |field|
      level = public_send(field) || ProjectFeature::ENABLED
      not_allowed = level > repository_access_level
      self.errors.add(field, "cannot have higher visibility level than repository access level") if not_allowed
    end

    %i(merge_requests_access_level builds_access_level).each(&validator)
  end

  def get_permission(user, level)
    case level
    when DISABLED
      false
    when PRIVATE
      user && (project.team.member?(user) || user.admin?)
    when ENABLED
      true
    else
      true
    end
  end
end
