### Settings ###
util = require("gulp-util")
s =
	min: util.env.min

# Project Paths
input =
	styles: "less"

output =
	dir: "../css"
	css: "map.css"

### Pacakages ###
child_process = require "child_process"
del           = require "del"
gulp          = require "gulp"
merge         = require "merge-stream"

### Plugins ###
g = require("gulp-load-plugins")({replaceString: /^gulp(-|\.)|-/g})
p =
  autoprefixer: require "autoprefixer"
  gradient:     require "postcss-filter-gradient"
  opacity:      require "postcss-opacity"
  rgba:         require "postcss-color-rgba-fallback"
  plsfilters:   require "pleeease-filters"


### Helpers ###

glob = (path) ->
  "#{path}/*"

### Tasks ###
gulp.task "default", ["styles"]

gulp.task "clean", ->
  del "#{output.dir}/#{output.css}", {force: true}

gulp.task "styles", ["clean"], ->
  main = gulp.src glob input.styles
    .pipe g.filter(["*.less", "!_*.less"])
    .pipe g.less({paths: [input.images]})
    .pipe g.postcss([
      p.autoprefixer({browsers: ["last 2 versions", "ie >= 9"]}),
      p.gradient,
      p.opacity,
      p.rgba,
      p.plsfilters
      ])

  combined = main
  combined
    .pipe g.if(s.min, g.cssnano({discardComments: {removeAll: true}}), g.csscomb())
    .pipe g.concat(output.css)
    .pipe gulp.dest output.dir