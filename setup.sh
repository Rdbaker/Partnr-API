sudo apt-get update
sudo apt-get install build-essential zlib1g-dev git-core gnupg2 libpq-dev postgresql nodejs
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -L https://get.rvm.io | bash -s stable --ruby
source /home/vagrant/.rvm/scripts/rvm
source ~/.profile
rvm use 2.0.0
bundle install
# sudo -u postgres -i
# createuser -s vagrant

rake db:setup
rake db:create
rake db:migrate
