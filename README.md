##Set up the environment
to set up the environment for development you must have Virtualbox and Vagrant installed
run the following commands:
`vagrant up`
`vagrant ssh`
once inside the vagrant machine type:
`cd /vagrant`
`sudo ./setup.sh`
make sure you pay attention here as there's a portion where you need to switch the user and
create a new user for the database
the commands to do this are in the setup.sh file, run those two commands, then run:
`exit`
once that is done you can run the rest of the setup.sh script
