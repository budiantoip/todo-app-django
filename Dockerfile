# Use an official Python runtime as a parent image
FROM python:3.8-slim as builder

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1


# Set the working directory in the container
WORKDIR /code

# Install system dependencies
RUN apt-get update && apt-get install -y python3-dev default-libmysqlclient-dev build-essential pkg-config

# Install Python dependencies
COPY requirements.txt /code/

# Set MYSQLCLIENT environment variables
RUN echo "export MYSQLCLIENT_CFLAGS=$(pkg-config mysqlclient --cflags)" >> /etc/profile && \
    echo "export MYSQLCLIENT_LDFLAGS=$(pkg-config mysqlclient --libs)" >> /etc/profile
    
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the current directory contents into the container at /code
COPY . /code/

# Collect static files
RUN python manage.py collectstatic --noinput

# Run migrations
# RUN python manage.py migrate

# Command to run the app
CMD ["bash", "docker-entrypoint.sh"]