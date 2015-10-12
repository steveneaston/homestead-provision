# Laravel Homestead Provision Scripts

Inspired by [Vaprobash](https://github.com/fideloper/Vaprobash) by [fideloper](https://github.com/fideloper).

## Goal

The goal of this project is to create easy to use bash scripts in order to provision per-project Homestead servers.

## Installation

Follow the [official Laravel Documentation](http://laravel.com/docs/master/homestead#per-project-installation) to install Homestead per project.

Add the following provisioners into `Vagrantfile` located in the root of your project. Add this before the final `end`.

```ruby
# Provision MongoDB
config.vm.provision "shell", path: "https://raw.githubusercontent.com/steveneaston/homestead-provision/scripts/mongodb.sh", args: ["true", "3.0"]

# Provision PM2
config.vm.provision "shell", path: "https://raw.githubusercontent.com/steveneaston/homestead-provision/scripts/pm2.sh"

# Site settings
settings["sites"].each do |site|
    rootPath = site["to"].sub(/public$/, '');

    # Migrate database
    if (site.has_key?("migrate") && site["migrate"])
        config.vm.provision "shell",
            inline: "php " + rootPath + "artisan migrate"
    end

    # Install composer dependencies
    if (site.has_key?("composer") && site["composer"])
        config.vm.provision "shell",
            inline: "composer install -d " + rootPath
    end

    # Run queue worker
    if (site.has_key?("queue") && site["queue"])
        config.vm.provision "shell", path: "https://raw.githubusercontent.com/steveneaston/homestead-provision/scripts/queue-worker.sh", args: [rootPath, site["map"]]
    end

    # Spawn nodejs applications with PM2
    if (site.has_key?("pm2") && site["pm2"])
        site["pm2"].each do |njs|
            config.vm.provision "shell",
                inline: "pm2 start " + rootPath + njs
        end
    end
end
```

## Usage

You can add the following new options to each site within `Homestead.yaml`:

* `migrate`
* `composer`
* `queue`
* `pm2`

`migrate: true` runs migrations

`composer: true` installs composer dependencies

`queue: true` registers and starts a queue worker (Using the default connection with the options: `--sleep=10 --quiet --tries=3 --queue=default`)

`pm2` uses [PM2](https://github.com/Unitech/pm2) to spawn the given scripts.

```yaml
# Spawn an instance of `app.js` and `sockets.js`
# Files are discovered from the project root, e.g. `/home/vagrant/Code/MySite/`
sites:
    - map: mysite.app
      to: /home/vagrant/Code/MySite/public
      pm2:
        - app.js
        - sockets.js
```
