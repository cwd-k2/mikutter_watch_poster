require 'fileutils'
require 'listen'

watched_directory = '/tmp/mikutter/watch_post'

Plugin.create :watch_poster do
  FileUtils.mkdir_p watched_directory

  listener = Listen.to(watched_directory) do |_, added, _|
    if (filename = added.first)
      File.open(filename) do |f|
        world, = Plugin.filtering :world_current, nil
        compose world, body: f.read
      end

      FileUtils.rm filename
    end
  end

  listener.start
end
