#!/bin/bash


# here is how you can update the User Data of the web server cluster Instances to pull the database 
# address and port out of the terraform_remote_state data source and expose that information in the 
# HTTP response.... alos note that you should use ${server_port} and not ${var.server_port}
cat > index.html <<EOF
  <h1>Hello, World</h1>
  <p>DB address: ${db_address}</p>
  <p>DB port: ${db_port}</p>
EOF

nohup busybox httpd -f -p ${server_port} &
