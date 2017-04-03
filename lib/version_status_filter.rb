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
require 'redmine'

to_prepare = proc do
  unless IssueQuery
         .included_modules
         .include?(RedmineVersionStatusFilter::Patches::IssueQueryPatch)
    IssueQuery.send(:include,
                    RedmineVersionStatusFilter::Patches::IssueQueryPatch)
  end
end

Rails.configuration.to_prepare(&to_prepare) if Redmine::VERSION::MAJOR >= 2