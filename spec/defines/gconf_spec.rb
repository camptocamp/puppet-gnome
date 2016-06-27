require 'spec_helper'
describe 'gnome::gconf' do

  let(:title) { 'rspec' }

  let(:pre_condition) do
    "user { 'root': }"
  end

  context 'with no parameters set' do
    # Puppet 3: 'Must pass .* to'
    # Puppet 4: "expects a value for parameter'
    it 'should fail' do
      expect {
        should contain_class(subject)
      }.to raise_error(Puppet::Error,/(Must pass .* to|expects a value for parameter)/)
    end
  end

  context 'with mandatory parameters set' do
    let(:params) do
      {
        :user    => 'root',
        :keyname => '/desktop/gnome/background/picture_filename',
        :type    => 'string',
        :value   => '/usr/share/wallpapers/rspec.png',
      }
    end
    it { should compile.with_all_deps }

    it {
      should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user root').with({
        'command' => "su -l -c \"/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --type string '/usr/share/wallpapers/rspec.png'\" root",
        'unless'  => "test \"/usr/share/wallpapers/rspec.png\" != \"\" && su -l -c 'test \"$(/usr/bin/gconftool-2 --get /desktop/gnome/background/picture_filename)\" == \"/usr/share/wallpapers/rspec.png\"' root",
        'require' => 'User[root]',
        'path'    => '/bin:/usr/bin',
      })
    }
  end

  context 'with schema set to valid string <org.gnome.desktop.wm.preferences>' do
    let(:params) do
      {
        :user    => 'root',
        :keyname => '/desktop/gnome/background/picture_filename',
        :type    => 'string',
        :value   => '/usr/share/wallpapers/rspec.png',
        :schema  => 'org.gnome.desktop.wm.preferences',
      }
    end
    it { should compile.with_all_deps }

    it {
      should contain_exec('set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user root').with({
        'command' => "su -l -c \"/usr/bin/gconftool-2 --set /desktop/gnome/background/picture_filename --type string '/usr/share/wallpapers/rspec.png'\" root",
        'unless'  => "test \"/usr/share/wallpapers/rspec.png\" != \"\" && su -l -c 'test \"$(/usr/bin/gconftool-2 --get /desktop/gnome/background/picture_filename)\" == \"/usr/share/wallpapers/rspec.png\"' root",
        'require' => 'User[root]',
        'path'    => '/bin:/usr/bin',
      })
    }

    it {
      should contain_exec('set default schema entry for /desktop/gnome/background/picture_filename in root').with({
        'command' => "su -l -c 'gconftool-2 --apply-schema org.gnome.desktop.wm.preferences /desktop/gnome/background/picture_filename' root",
        'unless'  => "test \"org.gnome.desktop.wm.preferences\" == \"$(su -l -c '/usr/bin/gconftool-2 --get-schema-name /desktop/gnome/background/picture_filename' root)\"",
        'require' => 'Exec[set param /desktop/gnome/background/picture_filename with value /usr/share/wallpapers/rspec.png for user root]',
        'path'    => '/bin:/usr/bin',
      })
    }
  end
end
