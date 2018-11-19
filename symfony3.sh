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

        root /var/www/html/$domain/web/;
        index index.php index.html index.htm ;

        server_name $domain ;

        location / {
                #try_files \$uri \$uri/ =404;
		try_files \$uri /app_dev.php\$is_args\$args;
        }

        location ~ \.php$ {
                fastcgi_pass unix:/run/php/php7.0-fpm.sock;
                include fastcgi_params;
                fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
                include /etc/nginx/fastcgi.conf;
        }

}

EOF

# Link to make it available
sudo ln -s $block /etc/nginx/sites-enabled/

# Test configuration and reload if successful
sudo nginx -t && sudo service nginx reload



