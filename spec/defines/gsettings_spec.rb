require 'spec_helper'
describe 'gnome::gsettings' do
  let(:title) { 'rspec' }
  let(:mandatory_params) do
    {
      :schema  => 'org.rspec.testing',
      :key     => '/desktop/gnome/rspec/testing',
      :value   => '/usr/rspec/testing',
    }
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
    content = <<-END.gsub(/^\s+\|/, '')
      |[org.rspec.testing]
      |  /desktop/gnome/rspec/testing = /usr/rspec/testing
    END

    it { should compile.with_all_deps }

    it do
      should contain_file('/usr/share/glib-2.0/schemas/25_rspec.gschema.override').with({
        'content' => content,
        'notify'  => ['Exec[change-org.rspec.testing-/desktop/gnome/rspec/testing]'],
      })
    end

    it do
      should contain_exec('change-org.rspec.testing-/desktop/gnome/rspec/testing').with({
        'command'     => '/usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas',
        'refreshonly' => true,
      })
    end
  end

  context 'with schema set to valid string <org.schema.testing>' do
    let(:params) do
      mandatory_params.merge({
        :schema => 'org.schema.testing',
      })
    end
    content = <<-END.gsub(/^\s+\|/, '')
      |[org.schema.testing]
      |  /desktop/gnome/rspec/testing = /usr/rspec/testing
    END

    it { should compile.with_all_deps }

    it do
      should contain_file('/usr/share/glib-2.0/schemas/25_rspec.gschema.override').with({
        'content' => content,
        'notify'  => ['Exec[change-org.schema.testing-/desktop/gnome/rspec/testing]'],
      })
    end

    it { should contain_exec('change-org.schema.testing-/desktop/gnome/rspec/testing') }
  end

  context 'with key set to valid string </desktop/gnome/key/testing>' do
    let(:params) do
      mandatory_params.merge({
        :key => '/desktop/gnome/key/testing',
      })
    end
    content = <<-END.gsub(/^\s+\|/, '')
      |[org.rspec.testing]
      |  /desktop/gnome/key/testing = /usr/rspec/testing
    END

    it { should compile.with_all_deps }

    it do
      should contain_file('/usr/share/glib-2.0/schemas/25_rspec.gschema.override').with({
        'content' => content,
        'notify'  => ['Exec[change-org.rspec.testing-/desktop/gnome/key/testing]'],
      })
    end

    it { should contain_exec('change-org.rspec.testing-/desktop/gnome/key/testing') }
  end

  context 'with value set to valid string </usr/value/testing>' do
    let(:params) do
      mandatory_params.merge({
        :value => '/usr/value/testing',
      })
    end
    content = <<-END.gsub(/^\s+\|/, '')
      |[org.rspec.testing]
      |  /desktop/gnome/rspec/testing = /usr/value/testing
    END

    it { should compile.with_all_deps }

    it do
      should contain_file('/usr/share/glib-2.0/schemas/25_rspec.gschema.override').with({
        'content' => content,
      })
    end
  end

  context 'with directory set to valid string </directory/testing>' do
    let(:params) do
      mandatory_params.merge({
        :directory => '/directory/testing',
      })
    end

    it { should compile.with_all_deps }
    it { should contain_file('/directory/testing/25_rspec.gschema.override') }

    it do
      should contain_exec('change-org.rspec.testing-/desktop/gnome/rspec/testing').with({
        'command' => '/usr/bin/glib-compile-schemas /directory/testing',
      })
    end
  end

  context 'with priority set to valid string <42>' do
    let(:params) do
      mandatory_params.merge({
        :priority => '42',
      })
    end

    it { should compile.with_all_deps }
    it { should contain_file('/usr/share/glib-2.0/schemas/42_rspec.gschema.override') }
  end
end
