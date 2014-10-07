# == Definition: gnome::gsettings
#
# Sets a configuration key in Gnome’s GSettings registry.
#
define gnome::gsettings(
  $schema,
  $key,
  $value,
  $directory = '/usr/share/glib-2.0/schemas',
  $priority  = '25',
) {
  file { "${directory}/${priority}_${name}.gschema.override":
    content => "[${schema}]\n  ${key} = ${value}\n",
  }
  ~>
  exec { "/usr/bin/glib-compile-schemas ${directory}":
    refreshonly => true,
  }
}
