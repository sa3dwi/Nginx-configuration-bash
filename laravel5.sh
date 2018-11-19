#!/bin/bash

domain=$1
root="/var/www/$domain"
block="/etc/nginx/sites-available/$domain"

# Create the Document Root directory
sudo mkdir -p $root

# Assign ownership to your regular user account
sudo chown -R $USER:$USER $root

# Create the Nginx server block file:
sudo tee $block > /dev/null <<EOF 
server {
        listen 80;
        listen [::]:80;

        root /var/www/html/$domain/public;
        index index.php index.html index.htm ;

        server_name $domain ;

        location / {
                #try_files \$uri \$uri/ =404;
		try_files \$uri \$uri/ /index.php\$is_args\$args;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.2-fpm.sock;
        }

}


EOF

# Link to make it available
sudo ln -s $block /etc/nginx/sites-enabled/

# Test configuration and reload if successful
sudo nginx -t && sudo service nginx reload
