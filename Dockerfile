# App
#
# VERSION               0.0.1

# Use the barebones version of Ruby 2.2.3.
#FROM rails:5.0.0.1
FROM rails:4.1.8

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Victor Hakoun <victor@hakoun.fr>

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH

# Install image magic
RUN apt-get update && apt-get install -y \
  imagemagick \
  libmagickwand-dev


# This sets the context of where commands will be ran in and is documented
# on Docker's website extensively.
WORKDIR $INSTALL_PATH

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
COPY Gemfile Gemfile
RUN bundle install

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . .

# Create database
RUN bin/rake db:setup
# Precompile assets
RUN bin/rake assets:precompile

EXPOSE 3000
CMD SECRET_KEY_BASE=`bin/rake secret` bin/rails server -b 0.0.0.0

