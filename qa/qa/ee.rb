module QA
  ##
  # GitLab EE extensions
  #
  module EE
    module Runtime
      autoload :Env, 'qa/ee/runtime/env'
      autoload :Geo, 'qa/ee/runtime/geo'
    end

    module Page
      module Dashboard
        autoload :Projects, 'qa/ee/page/dashboard/projects'
      end

      module Group
        autoload :Menu, 'qa/ee/page/group/menu'
        autoload :SamlSSOSignIn, 'qa/ee/page/group/saml_sso_sign_in'

        module Settings
          autoload :SamlSSO, 'qa/ee/page/group/settings/saml_sso'
        end
      end

      module Main
        autoload :Banner, 'qa/ee/page/main/banner'
      end

      module Admin
        autoload :Menu, 'qa/ee/page/admin/menu'
        autoload :License, 'qa/ee/page/admin/license'

        module Geo
          module Nodes
            autoload :Show, 'qa/ee/page/admin/geo/nodes/show'
            autoload :New, 'qa/ee/page/admin/geo/nodes/new'
          end
        end
      end

      module Project
        autoload :Show, 'qa/ee/page/project/show'

        module Issue
          autoload :Index, 'qa/ee/page/project/issue/index'
        end

        module Settings
          autoload :ProtectedBranches, 'qa/ee/page/project/settings/protected_branches'
        end
      end

      module MergeRequest
        autoload :Show, 'qa/ee/page/merge_request/show'
      end
    end

    module Factory
      autoload :License, 'qa/ee/factory/license'

      module Geo
        autoload :Node, 'qa/ee/factory/geo/node'
      end
    end

    module Scenario
      module Test
        autoload :Geo, 'qa/ee/scenario/test/geo'
        module Integration
          autoload :GroupSAML, 'qa/ee/scenario/test/integration/group_saml'
        end
      end
    end
  end
end
