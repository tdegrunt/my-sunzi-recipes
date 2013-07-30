#
# Installs RVM
#
# Needs the following in your sunzi.yml:
#
# ---
# attributes:
#   rvm:
#     rubies:
#       -
#         default: true
#         gems:
#           - bundler
#         ruby: "1.9.3"
#       -
#         gems:
#           - bundler
#         ruby: jruby
#
if [ -d /usr/local/rvm ]; then
  echo 'RVM already installed'
else
  curl -L https://get.rvm.io | bash -s stable
fi

if ! grep -Fq "[[ -s /usr/local/rvm/scripts/rvm ]] && source /usr/local/rvm/scripts/rvm" ~/.bash_profile 2>&1; then
  echo '[[ -s /usr/local/rvm/scripts/rvm ]] && source /usr/local/rvm/scripts/rvm' >> ~/.bash_profile
fi
source ~/.bash_profile

# Install the rubies and their gems, it creates a 'global' gemset for each ruby it installs
echo 'gem: --no-ri --no-rdoc' > ~/.gemrc
<% if @attributes.rvm['rubies'] %>
  <% @attributes.rvm['rubies'].each do |ruby| %>
    if ! [[ "$(rvm list strings)"  =~ "<%=ruby['ruby']%>" ]]; then
      echo "Installing <%=ruby['ruby']%>"
      rvm install --autolibs=3 <%=ruby['ruby']%>
      rvm use --create <%=ruby['ruby']%>@global <%= ruby['default'] ? "--default" : "" %>

      # Install Gems
      <% ruby['gems'].each do |gem| -%>
      gem install <%=gem%>
      <% end %>
    fi
  <% end %>
<% end %>
