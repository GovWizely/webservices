# This deploy hook exists to enable GovWizely-specific (private)
# behaviors on GovWizely servers. This hook is designed not to
# fail if you do not have these files on your own server.
shared_files =
  begin
    node[:apps][:webservices][:shared_files] || [ ]
  rescue
    [ ]
  end

shared_files.each do |f|
  shared_file = "#{new_resource.deploy_to}/shared/#{f}"
  run "ln -fs #{shared_file} #{release_path}/#{f}" if ::File.exists?(shared_file)
end
