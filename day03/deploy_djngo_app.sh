#!/bin/bash

<<task
Deploy a Django app
task

code_clone(){

    echo "Cloning the Django app..."

    if [ -d "django-notes-app" ]; then
        echo "Code already exists"
    else
        git clone https://github.com/LondheShubham153/django-notes-app.git
    fi

    cd django-notes-app
}

install_requirements(){

    echo "Installing dependencies..."

    sudo apt-get update

    sudo apt-get install docker.io docker-compose nginx -y
}

required_restarts(){

    echo "Starting services..."

    sudo chown $USER /var/run/docker.sock

    sudo systemctl enable docker
    sudo systemctl enable nginx

    sudo systemctl restart docker
    sudo systemctl restart nginx
}

deploy(){

    echo "Building Docker image..."

    docker build -t notes-app .

    echo "Running container..."

    docker run -d -p 8000:8000 --name notes-app-container notes-app
}

echo "********** DEPLOYMENT STARTED **********"

if ! code_clone; then
    echo "Code clone failed"
    exit 1
fi

if ! install_requirements; then
    echo "Installation failed"
    exit 1
fi

if ! required_restarts; then
    echo "System fault detected"
    exit 1
fi

if ! deploy; then
    echo "Deployment failed, mailing the admin"
fi

echo "********** DEPLOYMENT DONE **********"
