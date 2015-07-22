require 'digest'

def get_version
  times = ''

  Dir['**/*'].each do | f |
    filename = f.to_s

    if File.directory?(filename)
      times += File.ctime(filename).to_s
    end
  end

  md5 = Digest::MD5.new
  md5.update(times)
  md5.to_s
end
