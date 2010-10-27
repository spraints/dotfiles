require 'erb'
require 'yaml'

def home
  File.expand_path('~')
end
def src
  File.expand_path('..', __FILE__)
end
def dotfiles
  FileList["*"].
    exclude('Rakefile').
    exclude(/README/).
    exclude(/\.erb$/).
    exclude('private.yml')
end
def erb_files
  FileList["*.erb"]
end
def erb_outputs
  erb_files.ext('')
end

desc "Move the specified DOTFILE here and symlink to it."
task :grab do
  ENV['DOTFILE'] or raise "DOTFILE argument is required (e.g. rake grab DOTFILE=.bashrc)"
  f = File.basename(ENV['DOTFILE'])
  f = '.' + f unless f =~ /^\./
  home_dotfile = File.expand_path f, home
  if File.symlink? home_dotfile
    puts "#{home_dotfile} is already a symlink."
  else
    src_dotfile = File.expand_path f[1,f.size], src
    if File.exists? src_dotfile
      puts "#{src_dotfile} is in the way. Will not overwrite."
    else
      puts "mv #{home_dotfile} #{src_dotfile}"
      File.rename home_dotfile, src_dotfile
      puts "ln -s #{src_dotfile} #{home_dotfile}"
      File.symlink src_dotfile, home_dotfile
    end
  end
end

desc "Evaluate erbs with the configuration from private.yml"
task(:erb => erb_outputs.collect{|f| "erb:#{f}"})

def dotfile_erb(input, output)
  $config ||= YAML.load_file('private.yml')
  erb = ERB.new(File.read(input))
  erb.filename = input
  File.open(output, 'w') do |io|
    io << erb.result(OpenStruct.new($config).instance_eval{binding})
  end
end

namespace :erb do
  erb_outputs.each do |f|
    f_erb = f + '.erb'
    f_bak = f + '.bak'

    desc "Generate #{f} from #{f_erb}"
    task f => f_erb do
      if !File.exists?(f) || File.mtime(f_erb) > File.mtime(f)
        if File.exists? f
          File.rename f, f_bak
        end
        dotfile_erb(f_erb, f)
        puts "erb #{f_erb} > #{f}"
        if File.exists? f_bak
          system 'diff', f_bak, f
          File.unlink f_bak
        end
      end
    end
  end
end

desc "See what's changed in ERB-generated files."
task(:diff => erb_outputs.collect { |f| "diff:#{f}" })

namespace :diff do
  erb_outputs.each do |f|
    f_erb = f + '.erb'
    f_tmp = f + '.tmp'

    task f do
      dotfile_erb(f_erb, f_tmp)
      puts "diff #{f_erb} .#{f}"
      system 'diff', f_tmp, f
      File.unlink f_tmp
    end
  end
end

desc "Make symlinks for any dotfiles that aren't already links."
task :install => :erb do
  dotfiles.each do |file|
    target = File.join(home, ".#{File.basename file}")
    if File.symlink? target
      targettarget = File.readlink target
      if targettarget != File.expand_path(file)
	puts "#{target} already exists, and points to #{targettarget}!"
      end
    elsif File.exists?(target)
      puts "#{target} already exists! Maybe you should rake grab it!"
    else
      puts "#{target} -> #{file}"
      File.symlink File.expand_path(file), target
    end
  end
end

desc 'Remove all links here from home dotfiles'
task :uninstall do
  dotfiles.each do |file|
    target = File.join(home, ".#{File.basename file}")
    if File.exists?(target) && File.symlink?(target)
      cur = File.readlink target
      if file == cur
        puts "rm #{target}"
        File.unlink target
      end
    end
  end
end

task :default => :install
