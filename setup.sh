sudo apt-get update
sudo apt-get install build-essential zlib1g-dev git-core gnupg2 libpq-dev nodejs npm postgresql phantomjs
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -L https://get.rvm.io | bash -s stable --ruby
source /home/vagrant/.rvm/scripts/rvm
rvm install ruby-2.0.0
source ~/.profile
rvm use 2.0.0
gem install bundler
bundle install
gem install mailcatcher
sudo npm install bower -g
sudo ln -s /usr/bin/nodejs /usr/bin/node

#### do this part by hand #####
# sudo -u postgres -i
# createuser -s vagrant
# exit

# rake db:setup
