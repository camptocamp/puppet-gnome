# Puppet-gnome

Basic puppet-drive gnome configuration for user environments

[![Puppet Forge](http://img.shields.io/puppetforge/v/camptocamp/gnome.svg)](https://forge.puppetlabs.com/camptocamp/gnome)
[![Build Status](https://travis-ci.org/camptocamp/puppet-gnome.png?branch=master)](https://travis-ci.org/camptocamp/puppet-gnome)

## gconf or gsettings

GConf is the older Gnome configuration system (shipped `<= Ubuntu Lucid) and
GSettings is the newer equivalent.

In current Gnome versions(11/2011), the migration of application between GConf
and GSettings in progress, so both systems may be used depending on the
application you want to configure.

## Example

The following example sets the user's Window Manager **theme** preference
to be 'Ambiance'

```
gnome::gsettings { "wmpref":
  schema => "org.gnome.desktop.wm.preferences",
  key    => "theme",
  value  => "Ambiance",
}
```
