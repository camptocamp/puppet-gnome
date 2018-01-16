# == Definition: gnome::gsettings
#
# Sets a configuration key in Gnome's GSettings registry.
#
define gnome::gsettings(
  $schema,
  $key,
  $value,
  $directory = '/usr/share/glib-2.0/schemas',
  $priority  = '25',
  $user = undef,
) {
  if ($user == undef) {
    file { "${directory}/${priority}_${name}.gschema.override":
      content => "[${schema}]\n  ${key} = ${value}\n",
    }

    ~> exec { "change-${schema}-${key}":
      command     => "/usr/bin/glib-compile-schemas ${directory}",
      refreshonly => true,
    }
  } else {
    exec { "change-${schema}-${key}":
      command => "dbus-launch gsettings set ${schema} ${key} ${value}",
      path    => '/usr/bin',
      user    => $user,
    }
  }
}
