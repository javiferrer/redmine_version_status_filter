#
# Redmine Version Status Filter
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>

module RedmineVersionStatusFilter
  module Patches
    # Add a new filter in IssueQuery
    # with the version status
    module IssueQueryPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          alias_method_chain :initialize_available_filters,
                             :version_status_filter
        end
      end

      # Methods to add a new filter
      # called "version status"
      module InstanceMethods
        def initialize_available_filters_with_version_status_filter
          initialize_available_filters_without_version_status_filter
          add_version_status_filter
        end

        def add_version_status_filter
          v_statuses = Version::VERSION_STATUSES
          statuses = v_statuses.collect { |s| [l("version_status_#{s}"), s] }
          add_available_filter 'version_status_id',
                               type: :list,
                               values: statuses
        end

        def sql_for_version_status_id_field(field, operator, value)
          db_table = Version.table_name
          "#{Issue.table_name}.fixed_version_id
            #{operator == '=' ? 'IN' : 'NOT IN'}
            (SELECT #{db_table}.id FROM #{db_table} WHERE " +
            sql_for_field(field, '=', value, db_table, 'status') + ')'
        end
      end
    end
  end
end
