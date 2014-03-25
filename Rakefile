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
  FileUtils.cp_r("#{import_dir}/Exercises/Scripting", ".")
end


  

