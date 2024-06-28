FROM ruby:2.7.2

# Add Yarn package repository
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Add NodeSource repository for Node.js 14.x (or another supported version)
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

# Update package list and install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential libpq-dev nodejs postgresql-client yarn

# Create application directory
RUN mkdir /sample_rails_application
WORKDIR /sample_rails_application

# Copy Gemfile and Gemfile.lock
COPY Gemfile /sample_rails_application/Gemfile
COPY Gemfile.lock /sample_rails_application/Gemfile.lock

# Copy package.json and yarn.lock
COPY package.json /sample_rails_application/package.json
COPY yarn.lock /sample_rails_application/yarn.lock

# Install bundler and gems
RUN gem install bundler -v '2.2.15'
RUN bundle install

# Install node modules using Yarn
RUN yarn install --check-files

# Copy the rest of the application code
COPY . /sample_rails_application

# Expose the port the app runs on
EXPOSE 3000

# Define the command to run the application
#CMD ["rails", "server", "-b", "0.0.0.0"]
