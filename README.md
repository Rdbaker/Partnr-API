##Set up the environment
to set up the environment for development you must have Virtualbox and Vagrant installed
run the following commands:

`vagrant up`
`vagrant ssh`

once inside the vagrant machine type:

`cd /vagrant`
`sudo ./setup.sh`

Some of the commands inside the setup.sh file must be done manually. If you have any questions about the commands in the file, contact Ryan.


## Set up the mailer
For local development, you should set up a local emailer. Our email tool, mailcatcher, recommends that we install it ourselves instead of putting it into our Gemfile.

To install mailcatcher run:

`gem install mailcatcher`

then you should run mailcatcher in the background with the command:

`mailcatcher --http-ip=0.0.0.0`


## Run the server
To run the server, you should use the command:

`local=true rails s -b 0.0.0.0`

That will start a local server running on port 3000. You can connect to this by going to [localhost:3000](localhost:3000).
