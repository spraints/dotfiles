require 'erb'
require 'yaml'
require 'ostruct'

class Dotfiles < Thor
  include Thor::Actions

  desc "grab file...", "Move the specified file here and symlink to it."
  method_options :test => :boolean
  def grab(*files)
    if files.empty?
      say shell.set_color("grab: You must include at least one file to grab!", :red, true)
    end
    files.each do |file|
      f = File.basename file
      f = '.' + f unless f =~ /^\./
      home_dotfile = File.expand_path f, home
      if File.symlink? home_dotfile
        say shell.set_color("grab: #{home_dotfile} is already a symlink.", :red)
      else
        src_dotfile = File.expand_path f[1,f.size], src
        if File.exists? src_dotfile
          say shell.set_color("grab: #{src_dotfile} is in the way. Will not overwrite.", :red, true)
        else
          say "mv #{home_dotfile} #{src_dotfile}"
          File.rename home_dotfile, src_dotfile unless options[:test]
          say "ln -s #{src_dotfile} #{home_dotfile}"
          File.symlink src_dotfile, home_dotfile unless options[:test]
        end
      end
    end
  end

  desc "erb [file...]", "Evaluate erbs with the configuration from private.yml"
  method_options :force => :boolean, :test => :boolean
  def erb(*files)
    files = erb_files if files.empty?
    files.each do |file|
      dest_file, erb_file, erb_output = get_erb_filenames(file)
      next unless File.exists? erb_file
      if options[:force] || !File.exists?(dest_file) || File.mtime(erb_file) > File.mtime(dest_file)
        say "erb #{erb_file} > #{dest_file}"
        begin
          dotfile_erb(erb_file, erb_output)
          if File.exists? dest_file
            system 'diff', dest_file, erb_output
          end
          if options[:test]
            File.unlink erb_output
          else
            if File.exists? dest_file
              File.unlink dest_file
            end
            File.rename erb_output, dest_file
          end
        rescue => e
          say shell.set_color("erb: #{file}: #{e}", :red, true)
        end
      else
        say shell.set_color("erb: #{erb_file} is older than #{dest_file}, so I assume it's up-to-date.", :yellow)
      end
    end
  end

  desc "diff [file...]", "See what would be changed by the 'erb' task."
  def diff(*files)
    files = erb_files if files.empty?
    files.each do |file|
      begin
        dest_file, erb_file, erb_output = get_erb_filenames(file)
        say shell.set_color("diff #{dest_file} #{erb_file}", nil, true)
        dotfile_erb(erb_file, erb_output)
        system 'diff', dest_file, erb_output
      rescue => e
        say shell.set_color("#{file}: #{e}", :red, true)
      ensure
        File.unlink erb_output if File.exists? erb_output
      end
    end
  end

  desc "install [file...]", "Make symlinks for any dotfiles that aren't already links."
  method_options :force => :boolean, :test => :boolean
  def install(*files)
    invoke :erb
    files = dotfiles if files.empty?
    files.each do |file|
      begin
        dest_file, src_file = get_filenames(file)
        if File.symlink? dest_file
          dest_target = File.readlink dest_file
          if dest_target != src_file
            if options[:force]
              do_install src_file, dest_file
            else
              say shell.set_color("install: #{file}: symlink to #{dest_target} is in the way!", :red)
            end
          end
        elsif File.exists? dest_file
          say shell.set_color("install: #{dest_file} already exists! Maybe you should grab it!", :red)
        else
          do_install src_file, dest_file
        end
      rescue => e
        say shell.set_color("install: #{file}: #{e}", :red, true)
      end
    end
  end

  desc "uninstall [file...]", 'Remove all links here from home dotfiles'
  method_options :test => :boolean, :all => :boolean
  def uninstall(*files)
    files = dotfiles if files.empty?
    files.each do |file|
      begin
        dest_file, src_file = get_filenames(file)
        if is_link_to? dest_file, src_file
          say "rm #{dest_file}"
          File.unlink dest_file unless options[:test]
        end
      rescue => e
        say shell.set_color("uninstall: #{file}: #{e}", :red, true)
      end
    end
  end

  private

  def is_link_to? dest, src
    File.symlink?(dest) &&
      File.readlink(dest) == src
  end

  def home
    File.expand_path('~')
  end

  def src
    File.dirname __FILE__
  end

  def dotfiles
    dotfiles = Dir["*"]
    dotfiles.reject! { |f| f == 'Thorfile' }
    dotfiles.reject! { |f| f =~ /^Gemfile/ }
    dotfiles.reject! { |f| f =~ /^README/i }
    dotfiles.reject! { |f| f == 'Brewfile' }
    dotfiles.reject! { |f| f == 'private.yml' }
    dotfiles.reject! { |f| f =~ /\.erb$/ }
    dotfiles.reject! { |f| f =~ /\.tmp$/ }
    dotfiles
  end

  def get_filenames(file)
    file = File.basename(file).sub(/^\.+/,'')
    src_file = File.join(src, file)
    dest_file = File.join(home, '.' + file)
    [dest_file, src_file]
  end

  def do_install(src_file, dest_file)
    if File.symlink?(dest_file) || File.exists?(dest_file)
      File.unlink dest_file unless options[:test]
    end
    say "ln -s #{src_file} #{dest_file}"
    File.symlink src_file, dest_file unless options[:test]
  end

  def erb_files
    Dir["**/*.erb"]
  end

  def get_erb_filenames(file)
    dest_file  = file.sub(/\.erb$/, '')
    erb_file   = dest_file + '.erb'
    erb_output = dest_file + '.tmp'
    [dest_file, erb_file, erb_output]
  end

  def dotfile_erb(input, output)
    $config ||= YAML.load_file('private.yml') rescue {}
    erb = ERB.new(File.read(input))
    erb.filename = input
    File.open(output, 'w') do |io|
      io << erb.result(ConfigHelper.new($config).instance_eval{binding})
    end
  end

  class ConfigHelper
    def initialize(config)
      @config = config
    end

    def method_missing(method, &block)
      case value = @config[method.to_s]
      when Hash
        ConfigHelper.new(value)
      when nil
        if @config.respond_to?(method)
          @config.send(method, &block)
        else
          nil
        end
      else
        value
      end
    end
  end
end
