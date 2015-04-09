sudo apt-get update
sudo apt-get install build-essential zlib1g-dev git-core gnupg2 libpq-dev postgresql phantomjs
curl -L https://get.rvm.io | bash -s stable --ruby
source /home/vagrant/.rvm/scripts/rvm
rvm install ruby-2.0.0-p598
source ~/.profile
rvm use 2.0.0
bundle install

#### do this part by hand #####
# sudo -u postgres -i
# createuser -s vagrant
# exit

# rake db:setup
