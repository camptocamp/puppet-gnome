require 'spec_helper'
describe 'gnome::gconf' do
  let(:title) { 'rspec' }
  let(:facts) do
    {
      :path    => '/bin:/usr/bin',
    }
  end
  let(:mandatory_params) do
    {
      :user    => 'root',
      :keyname => '/desktop/gnome/background/picture_filename',
      :type    => 'string',
      :value   => '/usr/share/wallpapers/rspec.png',
    }
  end
  let(:pre_condition) do
    "user { 'root': }"
  end

  context 'with no parameters set' do
    # Puppet 3: 'Must pass .* to'
    # Puppet 4: "expects a value for parameter'
    it 'should fail' do
      expect { should contain_class(subject) }.to raise_error(Puppet::Error, /(Must pass .* to|expects a value for parameter)/)
    end
  end

  context 'with mandatory parameters only set' do
    let(:params) { mandatory_params }
    it { should compile.with_all_deps }

    it do
      should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user root').with({
        'command' => "su -l -c \"/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --type string '/usr/share/wallpapers/rspec.png'\" root",
        'unless'  => "test \"/usr/share/wallpapers/rspec.png\" != \"\" && su -l -c 'test \"$(/usr/bin/gconftool-2 --get /desktop/gnome/background/picture_filename)\" == \"/usr/share/wallpapers/rspec.png\"' root",
        'require' => 'User[root]',
        'path'    => '/bin:/usr/bin',
      })
    end
  end

  context 'with user set to valid string <rspec>' do
    let(:params) do
      mandatory_params.merge({
        :user => 'rspec',
      })
    end
    let(:pre_condition) do
      "user { 'rspec': }"
    end
    it { should compile.with_all_deps }

    it do
      should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user rspec').with({
        'command' => "su -l -c \"/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --type string '/usr/share/wallpapers/rspec.png'\" rspec",
        'unless'  => "test \"/usr/share/wallpapers/rspec.png\" != \"\" && su -l -c 'test \"$(/usr/bin/gconftool-2 --get /desktop/gnome/background/picture_filename)\" == \"/usr/share/wallpapers/rspec.png\"' rspec",
        'require' => 'User[rspec]',
      })
    end

    context 'when list_type is set to a valid value' do
      let(:params) do
        mandatory_params.merge({
          :user      => 'rspec',
          :list_type => 'string',
        })
      end

      it do
        should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user rspec').with({
          'command' => "su -l -c \"/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --list-type string --type string '/usr/share/wallpapers/rspec.png'\" rspec",
          'unless'  => "test \"/usr/share/wallpapers/rspec.png\" != \"\" && su -l -c 'test \"$(/usr/bin/gconftool-2 --get /desktop/gnome/background/picture_filename)\" == \"/usr/share/wallpapers/rspec.png\"' rspec",
          'require' => 'User[rspec]',
        })
      end
    end

    context 'when list_type and list_append are set to a valid values' do
      let(:params) do
        mandatory_params.merge({
          :user        => 'rspec',
          :list_append => true,
          :list_type   => 'string',
        })
      end

      it do
        should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user rspec').with({
          'command' => "su -l -c '/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --list-type string --type string `echo $(gconftool-2  --get /desktop/gnome/background/picture_filename) | sed -e \"s/\\]/,/usr/share/wallpapers/rspec.png\\]/\"`' rspec",
          'unless'  => "su -l -c '/usr/bin/gconftool-2 --get /desktop/gnome/background/picture_filename' rspec | grep /usr/share/wallpapers/rspec.png",
          'require' => 'User[rspec]',
        })
      end
    end

    context 'when schema is set to a valid value' do
      let(:params) do
        mandatory_params.merge({
          :user   => 'rspec',
          :schema => 'org.gnome.desktop.wm.preferences',
        })
      end

      it do
        should contain_exec('set default schema entry for /desktop/gnome/background/picture_filename in rspec').with({
          'command' => "su -l -c 'gconftool-2 --apply-schema org.gnome.desktop.wm.preferences /desktop/gnome/background/picture_filename' rspec",
          'unless'  => "test \"org.gnome.desktop.wm.preferences\" == \"$(su -l -c '/usr/bin/gconftool-2 --get-schema-name /desktop/gnome/background/picture_filename' rspec)\"",
          'require' => 'Exec[set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user rspec]',
        })
      end
    end
  end

  context 'with keyname set to valid string </desktop/gnome/rspec/test>' do
    let(:params) do
      mandatory_params.merge({
        :keyname => '/desktop/gnome/rspec/test',
      })
    end
    it { should compile.with_all_deps }

    it do
      should contain_exec('set param /desktop/gnome/rspec/test with value /usr/share/wallpapers/rspec.png for user root').with({
        'command' => "su -l -c \"/usr/bin/gconftool-2 --set /desktop/gnome/rspec/test --type string '/usr/share/wallpapers/rspec.png'\" root",
        'unless'  => "test \"/usr/share/wallpapers/rspec.png\" != \"\" && su -l -c 'test \"$(/usr/bin/gconftool-2 --get /desktop/gnome/rspec/test)\" == \"/usr/share/wallpapers/rspec.png\"' root",
      })
    end

    context 'when list_type is set to a valid value' do
      let(:params) do
        mandatory_params.merge({
          :keyname   => '/desktop/gnome/rspec/test',
          :list_type => 'string',
        })
      end

      it do
        should contain_exec('set param /desktop/gnome/rspec/test with value /usr/share/wallpapers/rspec.png for user root').with({
          'command' => "su -l -c \"/usr/bin/gconftool-2 --set /desktop/gnome/rspec/test --list-type string --type string '/usr/share/wallpapers/rspec.png'\" root",
          'unless'  => "test \"/usr/share/wallpapers/rspec.png\" != \"\" && su -l -c 'test \"$(/usr/bin/gconftool-2 --get /desktop/gnome/rspec/test)\" == \"/usr/share/wallpapers/rspec.png\"' root",
        })
      end
    end

    context 'when list_type and list_append are set to a valid values' do
      let(:params) do
        mandatory_params.merge({
          :keyname     => '/desktop/gnome/rspec/test',
          :list_append => true,
          :list_type   => 'string',
        })
      end

      it do
        should contain_exec('set param /desktop/gnome/rspec/test with value /usr/share/wallpapers/rspec.png for user root').with({
          'command' => "su -l -c '/usr/bin/gconftool-2 --set /desktop/gnome/rspec/test --list-type string --type string `echo $(gconftool-2  --get /desktop/gnome/rspec/test) | sed -e \"s/\\]/,/usr/share/wallpapers/rspec.png\\]/\"`' root",
          'unless'  => "su -l -c '/usr/bin/gconftool-2 --get /desktop/gnome/rspec/test' root | grep /usr/share/wallpapers/rspec.png",
        })
      end
    end

    context 'when schema is set to a valid value' do
      let(:params) do
        mandatory_params.merge({
          :keyname => '/desktop/gnome/rspec/test',
          :schema  => 'org.gnome.desktop.wm.preferences',
        })
      end

      it do
        should contain_exec('set default schema entry for /desktop/gnome/rspec/test in root').with({
          'command' => "su -l -c 'gconftool-2 --apply-schema org.gnome.desktop.wm.preferences /desktop/gnome/rspec/test' root",
          'unless'  => "test \"org.gnome.desktop.wm.preferences\" == \"$(su -l -c '/usr/bin/gconftool-2 --get-schema-name /desktop/gnome/rspec/test' root)\"",
          'require' => 'Exec[set param /desktop/gnome/rspec/test with value /usr/share/wallpapers/rspec.png for user root]',
        })
      end
    end
  end

  context 'with type set to valid string <int>' do
    let(:params) do
      mandatory_params.merge({
        :type => 'int',
      })
    end
    it { should compile.with_all_deps }

    it do
      should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user root').with({
        'command' => "su -l -c \"/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --type int '/usr/share/wallpapers/rspec.png'\" root",
      })
    end

    context 'when list_type is set to a valid value' do
      let(:params) do
        mandatory_params.merge({
          :type      => 'int',
          :list_type => 'string',
        })
      end

      it do
        should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user root').with({
          'command' => "su -l -c \"/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --list-type string --type int '/usr/share/wallpapers/rspec.png'\" root",
        })
      end
    end

    context 'when list_type and list_append are set to a valid values' do
      let(:params) do
        mandatory_params.merge({
          :type        => 'int',
          :list_append => true,
          :list_type   => 'string',
        })
      end

      it do
        should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user root').with({
          'command' => "su -l -c '/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --list-type string --type int `echo $(gconftool-2  --get /desktop/gnome/background/picture_filename) | sed -e \"s/\\]/,/usr/share/wallpapers/rspec.png\\]/\"`' root",
        })
      end
    end
  end

  context 'with value set to valid string </rspec/test.png>' do
    let(:params) do
      mandatory_params.merge({
        :value => '/rspec/test.png',
      })
    end
    it { should compile.with_all_deps }

    it do
      should contain_exec('set param /desktop/gnome/background/picture_filename with value /rspec/test.png for user root').with({
        'command' => "su -l -c \"/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --type string '/rspec/test.png'\" root",
        'unless'  => "test \"/rspec/test.png\" != \"\" && su -l -c 'test \"$(/usr/bin/gconftool-2 --get /desktop/gnome/background/picture_filename)\" == \"/rspec/test.png\"' root",
      })
    end

    context 'when list_type is set to a valid value' do
      let(:params) do
        mandatory_params.merge({
          :value     => '/rspec/test.png',
          :list_type => 'string',
        })
      end

      it do
        should contain_exec('set param /desktop/gnome/background/picture_filename with value /rspec/test.png for user root').with({
          'command' => "su -l -c \"/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --list-type string --type string '/rspec/test.png'\" root",
          'unless'  => "test \"/rspec/test.png\" != \"\" && su -l -c 'test \"$(/usr/bin/gconftool-2 --get /desktop/gnome/background/picture_filename)\" == \"/rspec/test.png\"' root",
        })
      end
    end

    context 'when list_type and list_append are set to a valid values' do
      let(:params) do
        mandatory_params.merge({
          :value       => '/rspec/test.png',
          :list_append => true,
          :list_type   => 'string',
        })
      end

      it do
        should contain_exec('set param /desktop/gnome/background/picture_filename with value /rspec/test.png for user root').with({
          'command' => "su -l -c '/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --list-type string --type string `echo $(gconftool-2  --get /desktop/gnome/background/picture_filename) | sed -e \"s/\\]/,/rspec/test.png\\]/\"`' root",
          'unless'  => "su -l -c '/usr/bin/gconftool-2 --get /desktop/gnome/background/picture_filename' root | grep /rspec/test.png",
        })
      end
    end

    context 'when schema is set to a valid value' do
      let(:params) do
        mandatory_params.merge({
          :value  => '/rspec/test.png',
          :schema => 'org.gnome.desktop.wm.preferences',
        })
      end

      it do
        should contain_exec('set default schema entry for /desktop/gnome/background/picture_filename in root').with({
          'command' => "su -l -c 'gconftool-2 --apply-schema org.gnome.desktop.wm.preferences /desktop/gnome/background/picture_filename' root",
          'unless'  => "test \"org.gnome.desktop.wm.preferences\" == \"$(su -l -c '/usr/bin/gconftool-2 --get-schema-name /desktop/gnome/background/picture_filename' root)\"",
          'require' => 'Exec[set param /desktop/gnome/background/picture_filename with value /rspec/test.png for user root]',
        })
      end
    end
  end

  context 'with list_type set to valid string <float>' do
    let(:params) do
      mandatory_params.merge({
        :list_type => 'float',
      })
    end
    it { should compile.with_all_deps }

    it do
      should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user root').with({
        'command' => "su -l -c \"/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --list-type float --type string '/usr/share/wallpapers/rspec.png'\" root",
      })
    end

    context 'when list_append is set to a valid value' do
      let(:params) do
        mandatory_params.merge({
          :list_type   => 'float',
          :list_append => true,
        })
      end

      it do
        should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user root').with({
          'command' => "su -l -c '/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --list-type float --type string `echo $(gconftool-2  --get /desktop/gnome/background/picture_filename) | sed -e \"s/\\]/,/usr/share/wallpapers/rspec.png\\]/\"`' root",
        })
      end
    end
  end

  context 'with list_append set to valid boolean <true>' do
    let(:params) do
      mandatory_params.merge({
        :list_append => true,
      })
    end
    it { should compile.with_all_deps }

    # list_append is ignored without list_type being set too, so we se the default behaviour here
    it do
      should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user root').with({
        'command' => "su -l -c \"/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --type string '/usr/share/wallpapers/rspec.png'\" root",
        'unless'  => "test \"/usr/share/wallpapers/rspec.png\" != \"\" && su -l -c 'test \"$(/usr/bin/gconftool-2 --get /desktop/gnome/background/picture_filename)\" == \"/usr/share/wallpapers/rspec.png\"' root",
        'require' => 'User[root]',
      })
    end

    context 'when list_type is set to a valid value' do
      let(:params) do
        mandatory_params.merge({
          :list_append => true,
          :list_type   => 'float',
        })
      end

      it do
        should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user root').with({
          'command' => "su -l -c '/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --list-type float --type string `echo $(gconftool-2  --get /desktop/gnome/background/picture_filename) | sed -e \"s/\\]/,/usr/share/wallpapers/rspec.png\\]/\"`' root",
          'unless'  => "su -l -c '/usr/bin/gconftool-2 --get /desktop/gnome/background/picture_filename' root | grep /usr/share/wallpapers/rspec.png",
        })
      end
    end
  end

  context 'with schema set to valid string <org.gnome.desktop.wm.preferences>' do
    let(:params) do
      mandatory_params.merge({
        :schema => 'org.gnome.desktop.wm.preferences',
      })
    end
    it { should compile.with_all_deps }

    it { should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user root') }

    it do
      should contain_exec('set default schema entry for /desktop/gnome/background/picture_filename in root').with({
        'command' => "su -l -c 'gconftool-2 --apply-schema org.gnome.desktop.wm.preferences /desktop/gnome/background/picture_filename' root",
        'unless'  => "test \"org.gnome.desktop.wm.preferences\" == \"$(su -l -c '/usr/bin/gconftool-2 --get-schema-name /desktop/gnome/background/picture_filename' root)\"",
        'path'    => '/bin:/usr/bin',
      })
    end
  end
end
