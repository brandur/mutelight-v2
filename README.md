Mutelight
=========

Article content for [Mutelight](https://mutelight.org). Designed to be powered by the [Hekla](https://github.com/brandur/hekla) platform.

Content in this repository is all rights reserved.

Installation
------------

1. Follow the setup instructions over at [Hekla](https://github.com/brandur/hekla).
2. Export script configuration:

        export MUTELIGHT_HOST="https://mutelight.herokuapp.com"
        export MUTELIGHT_HTTP_API_KEY="xxx"
        export MUTELIGHT_BUCKET="mutelight" # S3 bucket for images

3. Sync images to S3:

        bin/sync-images

4. Publish the article content:

        bin/mass-create articles/
