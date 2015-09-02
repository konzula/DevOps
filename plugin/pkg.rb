

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

Ohai.plugin(:PackageInfo) do
  provides "package"
  
  depends "platform_family"
  
  collect_data do
    pckg_list = Hash.new
    case platform_family
      when 'debian'
        pckg_list = eval '{'+`dpkg-query -W -f='"${Package}"=> { "version" => "${Version}" }, '`+'}'
      when 'rhel' || 'fedora'
        pckg_list = eval '{'+`rpm -qa --queryformat '"%{NAME}"=> \\{ "version"=> "%{VERSION}", \\}, '`+'}'
      when 'arch'
        pckg_list = eval '{'+`package-query -Q -f '"%n"=> { "version"=> "%v", }, '`+'}'
      when 'gentoo'
        pckg_list = eval '{'+`equery list --format='"$name" => { "version"=> "$version", }, ' '*'`+'}'
      end                                                                                                    
      package Mash.new pckg_list
    end                                                                                                                   
  end       
