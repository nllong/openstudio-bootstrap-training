require 'logger'
logger = Logger.new(STDOUT)

desc "Import files from OpenStudio-training repo"
task :import_files do
  require 'git'
  logger.info "Making sure OpenStudio-training git repo is up-to-date"
  import_dir = "../OpenStudio-training"
  g = Git.open(import_dir, :log => logger)
  g.pull

  logger.info "Copying over files into this repo"
  FileUtils.cp_r "#{import_dir}/Exercises/Scripting", "."
end

desc "Run all examples"
task :run_all do
  files = Dir.glob("./**/ex*.rb").delete_if {|x| x =~ /.*solution.*/ }
  files.each do |file|
    currentdir = Dir.pwd
    logger.info "Changing to directory #{File.dirname(file)}"
    run_dir = Dir.chdir File.dirname(file)
    logger.info "Running #{File.basename(file)}"
    logger.info `ruby #{File.basename(file)}`
    #copy the output to solution
    get_ex = file.scan(/ex(.*).rb/).first
    logger.info "Exercise version is #{get_ex}"
    Dir.chdir currentdir
  end
end
