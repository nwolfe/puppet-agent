component 'dmidecode' do |pkg, settings, platform|
  pkg.version '2.12'
  pkg.md5sum '02ee243e1ecac7fe0d04428aec85f63a'
  pkg.url "http://download.savannah.gnu.org/releases/dmidecode/dmidecode-#{pkg.get_version}.tar.gz"
  pkg.mirror "http://buildsources.delivery.puppetlabs.net/dmidecode-#{pkg.get_version}.tar.gz"

  pkg.apply_patch "resources/patches/dmidecode/dmidecode-1.173.patch"
  pkg.apply_patch "resources/patches/dmidecode/dmidecode-1.175.patch"
  pkg.apply_patch "resources/patches/dmidecode/dmidecode-1.176.patch"
  pkg.apply_patch "resources/patches/dmidecode/dmidecode-1.177.patch"
  pkg.apply_patch "resources/patches/dmidecode/dmidecode-1.181.patch"
  pkg.apply_patch "resources/patches/dmidecode/dmidecode-1.182.patch"
  pkg.apply_patch "resources/patches/dmidecode/dmidecode-1.195.patch"
  pkg.apply_patch "resources/patches/dmidecode/dmidecode-install-to-bin.patch"

  pkg.environment "LDFLAGS", settings[:ldflags]
  pkg.environment "CFLAGS", settings[:cflags]

  pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"


  if platform.is_cross_compiled?
    # The Makefile doesn't honor environment overrides, so we need to
    # edit it directly for cross-compiling
    pkg.configure do
      ["sed -i \"s|gcc|/opt/pl-build-tools/bin/#{settings[:platform_triple]}-gcc|g\" Makefile"]
    end
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    [
      "#{platform[:make]} prefix=#{settings[:prefix]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
      "rm -f #{settings[:bindir]}/vpddecode #{settings[:bindir]}/biosdecode #{settings[:bindir]}/ownership",
      "rm -f #{settings[:mandir]}/man8/ownership.8 #{settings[:mandir]}/man8/biosdecode.8 #{settings[:mandir]}/man8/vpddecode.8"
    ]
  end
end

