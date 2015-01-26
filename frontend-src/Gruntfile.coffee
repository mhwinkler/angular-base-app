module.exports = ( grunt ) ->

	prependFilename = ( prepend, files ) ->
		output = []
		for file in files
			if file.substring(0,1) is '!' 
				output.push '!' + prepend + file.substring(1)
			else
				output.push prepend + file
		return output

	###
	This would take a src object of the form:
	{
		something:
			totally: "else"
		and: "this"
	}
	And extend the dest object with the following:
	{
		something_totally: "else"
		and: "this"
	}
	###
	flatExtend = ( dest, src, keyPath ) ->
		if typeof src is 'object'
			for key, value of src
				flatExtend( dest, value, ( keyPath and "#{ keyPath }_" or '' ) + key )
		else
			dest[ keyPath ] = src

		dest

	packageJson = grunt.file.readJSON 'package.json'

	vendorAllSource = [
		'angular/**/*.js'
		'angular-animate/**/*.js'
		'angular-messages/**/*.js'
		'angular-mocks/**/*.js'
		'angular-resource/**/*.js'
		'angular-route/**/*.js'
		'angular-ui-router/release/**/*.js'
		'angular-restmod/dist/**/*.js'
		'bootstrap/dist/**/*.js'
		'bootstrap/dist/**/*.css'
		'jquery/dist/**/*.js'
		'lodash/dist/**/*.js'
		'modernizr/**/*.js'
	]

	vendorFullJsFiles = [
		'vendor/modernizr/modernizr.js'
		'vendor/jquery/dist/jquery.js'
		'vendor/lodash/dist/lodash.compat.js'
		'vendor/angular/angular.js'
		'vendor/angular-animate/angular-animate.js'
		'vendor/angular-messages/angular-messages.js'
		'vendor/angular-mocks/angular-mocks.js'
		'vendor/angular-resource/angular-resource.js'
		'vendor/angular-route/angular-route.js'
		'vendor/angular-ui-router/release/angular-ui-router.js'
		'vendor/angular-restmod/dist/angular-restmod-bundle.js'
		'vendor/bootstrap/dist/js/bootstrap.js'
	]

	vendorMinJsFiles = [
		'vendor/modernizr/modernizr.js'
		'vendor/jquery/dist/jquery.min.js'
		'vendor/lodash/dist/lodash.compat.min.js'
		'vendor/angular/angular.min.js'
		'vendor/angular-animate/angular-animate.min.js'
		'vendor/angular-messages/angular-messages.min.js'
		# 'vendor/angular-mocks/angular-mocks.min.js'
		'vendor/angular-resource/angular-resource.min.js'
		'vendor/angular-route/angular-route.min.js'
		'vendor/angular-ui-router/release/angular-ui-router.min.js'
		'vendor/angular-restmod/dist/angular-restmod-bundle.min.js'
		'vendor/bootstrap/dist/js/bootstrap.min.js'
	]
	
	vendorMinCssFiles = [
		'vendor/bootstrap/dist/css/bootstrap.min.css'
		'vendor/bootstrap/dist/css/bootstrap-theme.min.css'
	]

	appJsFiles = [
		'app/**/app.js'
		'app/**/*.js'
		'<%= pkg.jsDir %>/template_cache.js'
		'!app/**/*_spec.js'
	]
	
	deployHtmlTarget =
		expand : yes
		flatten: yes
		src   : '.build/build_final_pass/app/index.html'
		dest  : '<%= pkg.deployHtmlTargetDir %>'

	preprocessContext = flatExtend {}, packageJson
	preprocessContext = flatExtend preprocessContext, packageJson.applicationConfig[ packageJson.environment ], 'applicationConfig'

	gruntConfig =
		pkg: packageJson

		clean: 
			options   :
				force : true
			all       : [ '.build/', 'vendor/', '<%= pkg.deployJsDir %>', '<%= pkg.deployCssDir %>', '<%= pkg.deployImagesDir %>', '<%= pkg.deployFontsDir %>' ] #'<%= pkg.deployHtmlTargetDir %>'
			coffee    : [ '.build/build_first_pass/app/**/*.coffee>', '.build/build_final_pass/<%= pkg.jsDir %>', '<%= pkg.deployJsDir %>' ]
			scss      : [ '.build/build_first_pass/app/**/*.scss', '.build/build_final_pass/<%= pkg.cssDir %>', '<%= pkg.deployCssDir %>' ] # '<%= pkg.deployHtmlTargetDir %>', '<%= pkg.deployCssDir %>'

		modernizr:
			dist:
				outputFile: 'vendor/modernizr/modernizr.js'
				uglify    : yes
				parseFiles: no
				extra     :
					shiv      : yes
					printshiv : no
					load      : no
					mq        : no
					cssclasses: yes
				extensibility:
					addtest     : no
					prefixed    : no
					teststyles  : yes
					testprops   : yes
					testallprops: yes
					hasevents   : no
					prefixes    : yes
					domprefixes : yes
				tests: [
					"backgroundsize"
					"flexbox"
					"rgba"
					"cssanimations"
					"cssgradients"
					"csstransitions"
					"input"
					"inputtypes"
					"css_backgroundsizecover"
					"css_boxsizing"
				]

		preprocess:
			options    : context: preprocessContext
			htmlTarget : 
				files: [ 
					expand : yes
					flatten: no
					cwd    : 'app'
					src    : [ 'index.html' ]
					dest   : '.build/build_first_pass/'
				]
			prepCoffee : 
				files: [
					expand : yes
					flatten: no
					src    : [ 'app/**/*.coffee' ]
					dest   : '.build/build_first_pass/'
				]
			prepScss : 
				files : [
					expand : yes
					flatten: no
					src    : [ 'app/**/*.scss' ]
					dest   : '.build/build_first_pass/'
				]
			prepJs : 
				files : [ 
					expand  : yes
					flatten : no
					src     : [ 'app/**/*.js' ]
					dest    : '.build/build_first_pass/'
				]
			prepCss : 
				files: [ 
					expand : yes
					flatten: no
					src    : [ 'app/**/*.css' ]
					dest   : '.build/build_first_pass/'
				]
			prepTemplates: 
				files: [ 
					expand : yes
					flatten: no
					src    : [ 'app/**/*.tpl', 'app/**/*.html', '!app/index.html' ]
					dest   : '.build/build_first_pass/'
				]

		copy: 
			bower:
				expand : yes
				flatten: no
				cwd : 'bower_components'
				src : vendorAllSource
				dest: 'vendor/'

			prep : 
				files : [ 
					# {
					# 	expand : yes
					# 	flatten: yes
					# 	src    : [ '**/<%= pkg.fontsDir %>/**/*' ]
					# 	dest   : '.build/build_first_pass/<%= pkg.fontsDir %>/'
					# }
					{
						expand : yes
						flatten: no
						src    : 'app/**/<%= pkg.imagesDir %>/**/*'
						dest   : '.build/build_first_pass/<%= pkg.imagesDir %>/'
						rename : (dest, src) ->
							# Remove the leading folders from src and place into dest
							return dest + src.split( '/' + packageJson.imagesDir + '/' ).slice(1).join('/')
					}
					{
						expand : yes
						flatten: no
						src    : [ 'vendor/**/*' ]
						dest   : '.build/build_first_pass/'
					}
				]
			
			buildStatics : 
				files : [ 
					# No support for fonts yet...
					{ # js
						expand : yes
						cwd    : '.build/build_first_pass'
						src    : 'app/**/*.js'
						dest   : '.build/build_final_pass/'
					}
					{ # css
						expand : yes
						cwd    : '.build/build_first_pass'
						src    : 'app/**/*.css'
						dest   : '.build/build_final_pass/'
					}
					{ # images
						expand : yes
						cwd    : '.build/build_first_pass'
						src    : '<%= pkg.imagesDir %>/**/*'
						dest   : '.build/build_final_pass/'
					}
					{ # templates
						expand : yes
						cwd    : '.build/build_first_pass/app'
						src    : [ '**/*.tpl', '**/*.html', '!index.html' ]
						dest   : '.build/build_final_pass/<%= pkg.templatesDir %>/'
					}
					{ # vendor js
						expand : yes
						flatten: no
						cwd    : '.build/build_first_pass'
						src    : vendorFullJsFiles
						dest   : '.build/build_final_pass/'
					}
					{ # vendor css
						expand : yes
						flatten: no
						cwd    : '.build/build_first_pass'
						src    : vendorMinCssFiles
						dest   : '.build/build_final_pass/'
					}
				]

			deployDev :
				files : [
					# doesn't yet support fonts
					{ # js
						expand: yes
						cwd: '.build/build_final_pass'
						src: appJsFiles
						dest: '<%= pkg.deployAssetsDir %>/'
					}
					{ # css
						expand: yes
						cwd: '.build/build_final_pass/app'
						src: '**/*.css'
						dest: '<%= pkg.deployAssetsDir %>/app/'
					}
					{ # images
						expand: yes
						cwd: '.build/build_final_pass/<%= pkg.imagesDir %>'
						src: '**/*'
						dest: '<%= pkg.deployImagesDir %>/'
					}
					{ # templates
						expand: yes
						cwd: '.build/build_final_pass/<%= pkg.templatesDir %>'
						src: '**/*'
						dest: '<%= pkg.deployTemplatesDir %>/'
					}
					{ # html
						expand: yes
						cwd: '.build/build_final_pass'
						src: 'index.html'
						dest: '<%= pkg.deployHtmlTargetDir %>/'
					}
					{ # vendor js
						expand: yes
						cwd  : '.build/build_final_pass'
						src  : vendorFullJsFiles
						dest : '<%= pkg.deployAssetsDir %>/'
					}
					{ # vendor css
						expand: yes
						cwd  : '.build/build_final_pass'
						src  : vendorMinCssFiles
						dest : '<%= pkg.deployAssetsDir %>/'
					}
				]

			deployProd: 
				files: [
					# doesn't yet support fonts
					{ # js
						expand: yes
						cwd: '.build/build_final_pass/<%= pkg.jsDir %>'
						src: '**/*.js'
						dest: '<%= pkg.deployJsDir %>/'
					}
					{ # css
						expand: yes
						cwd: '.build/build_final_pass/<%= pkg.cssDir %>'
						src: '**/*.css'
						dest: '<%= pkg.deployCssDir %>/'
					}
					{ # images
						expand: yes
						cwd: '.build/build_final_pass/<%= pkg.imagesDir %>'
						src: '**/*'
						dest: '<%= pkg.deployImagesDir %>/'
					}
					{ # templates
						expand: yes
						cwd: '.build/build_final_pass/<%= pkg.templatesDir %>'
						src: '**/*'
						dest: '<%= pkg.deployTemplatesDir %>/'
					}
					{ # html
						expand: yes
						cwd: '.build/build_final_pass'
						src: 'index.html'
						dest: '<%= pkg.deployHtmlTargetDir %>/'
					}
				]

		coffee:
			all: 
				expand : yes
				flatten: no
				cwd    : '.build/build_first_pass'
				src    : 'app/**/*.coffee'
				dest   : '.build/build_final_pass/'
				ext    : '.js'
			
		ngtemplates:
			ngApp:
				cwd     : '.build/build_final_pass/<%= pkg.templatesDir %>/'
				src     : [ '**/*.tpl', '**/*.html', '!index.html' ]
				dest    : '.build/build_final_pass/<%= pkg.jsDir %>/template_cache.js'
				options :
					module: packageJson.name
					url: ( url ) ->
						grunt.config.process "#{
							packageJson.applicationConfig[ packageJson.environment ].defaultScheme
						}#{
							packageJson.applicationConfig[ packageJson.environment ].staticFileDomain
						}/#{
							packageJson.applicationConfig[ packageJson.environment ].staticFileDirectory
						}/#{
							packageJson.templatesDir
						}/#{
							url
						}#{
							packageJson.applicationConfig[ packageJson.environment ].staticFileSuffix
						}"
					htmlmin:
						collapseBooleanAttributes: no
						collapseWhitespace       : yes
						removeAttributeQuotes    : yes
						removeComments           : yes
						removeEmptyAttributes    : yes
						removeRedundantAttributes: yes

		ngAnnotate :
			options :
				singleQuotes : yes
			app :
				files : [
					expand : yes
					cwd    : '.build/build_final_pass'
					src    : [ 'app/**/*.js' ]
					dest   : '.build/build_final_pass'
				]

		sass:
			options:
				compass   : yes
				sourcemap : 'none'
				loadPath  : [ '.build/build_first_pass/app/**/*.scss' ]
				style     : 'condensed'
				require   : 'animation'
			dist: 
				files: [
					expand  : yes
					flatten : no
					cwd     : '.build/build_first_pass'
					src     : 'app/**/*.scss'
					dest    : '.build/build_final_pass/'
					ext     : '.css'
				]

		concat:
			vendorPrettyJs :
				options : separator: ';\n'
				files: [
					{
						cwd : '.build/build_first_pass'
						src : vendorFullJsFiles
						dest: '.build/build_final_pass/<%= pkg.jsDir %>/vendor-pretty-all.js'
					}
				]

			vendorJs    :
				options : separator: ';\n'
				files: [
					{
						cwd : '.build/build_first_pass'
						src : vendorMinJsFiles
						dest: '.build/build_final_pass/<%= pkg.jsDir %>/vendor-all.js'
					}
				]

			vendorCss    :
				files: [
					{
						cwd : '.build/build_first_pass'
						src : vendorMinCssFiles 
						dest: '.build/build_final_pass/<%= pkg.cssDir %>/vendor-all.css'
					}
				]
				
			allPrettyJs :
				options : separator: ';\n'
				src     : prependFilename '.build/build_final_pass/', appJsFiles
				dest    : '.build/build_final_pass/<%= pkg.jsDir %>/pretty-all.js'

			allCss:
				src : '.build/build_final_pass/app/**/*.css'
				dest: '.build/build_final_pass/<%= pkg.cssDir %>/all.css'

		uglify:
			options:
				report: 'min'
				# mangle: false
			
			allJs:
				src  : '.build/build_final_pass/<%= pkg.jsDir %>/pretty-all.js'
				dest : '.build/build_final_pass/<%= pkg.jsDir %>/all.js'

		cssmin:
			options:
				report: 'min'
			allCss:
				src : '.build/build_final_pass/<%= pkg.cssDir %>/all.css'
				dest: '.build/build_final_pass/<%= pkg.cssDir %>/all.css'

		bless:
			options:
				cleanup: yes
			files:
				expand: yes
				cwd : '.build/build_final_pass/<%= pkg.cssDir %>'
				src : 'all.css'
				dest: '.build/build_final_pass/<%= pkg.cssDir %>/'
				rename : (dest, src) ->
					return dest + 'msie-' + src

		md5:
			js : 
				expand : yes
				cwd    : '.build/build_final_pass/<%= pkg.jsDir %>'
				src    : '**/*.js'
				dest   : '.build/build_final_pass/<%= pkg.jsDir %>/'
			css : 
				expand : yes
				cwd    : '.build/build_final_pass/<%= pkg.cssDir %>'
				src    : '**/*.css'
				dest   : '.build/build_final_pass/<%= pkg.cssDir %>/'
				
			options:
				keepBasename : yes
				keepExtension: yes

		htmlbuild:
			development:
				src    : '.build/build_first_pass/index.html'
				dest   : '.build/build_final_pass/'
				options:
					prefix : '/<%= pkg.staticFileDirectory %>/'
					scripts:
						vendor : prependFilename '.build/build_final_pass/', vendorFullJsFiles
						app    : prependFilename '.build/build_final_pass/', appJsFiles
					styles:
						vendor : prependFilename '.build/build_final_pass/', vendorMinCssFiles 
						app    : [ '.build/build_final_pass/app/**/*.css' ]
						appIE  : [ '.build/build_final_pass/<%= pkg.cssDir %>/msie-all*-*.css' ]

			production:
				src    : '.build/build_first_pass/index.html'
				dest   : '.build/build_final_pass/'
				options:
					prefix : '/<%= pkg.staticFileDirectory %>/'
					scripts:
						vendor : [ '.build/build_final_pass/<%= pkg.jsDir %>/**/vendor-all-*.js' ]
						app    : [ '.build/build_final_pass/<%= pkg.jsDir %>/**/all-*.js' ]
					styles:
						vendor : [ '.build/build_final_pass/<%= pkg.cssDir %>/vendor-all-*.css' ]
						app    : [ '.build/build_final_pass/<%= pkg.cssDir %>/all-*.css' ]
						appIE  : [ '.build/build_final_pass/<%= pkg.cssDir %>/all*-ie-*.css' ]

		watch:
			options:
				livereload: yes # packageJson.liveReloadPort
				verbose   : yes
			gruntfile:
				files: [ 'Gruntfile.coffee', 'package.json' ]
				tasks: [ '<%= pkg.environment %>' ]
			scss:
				files: [ 'app/**/*.scss', 'app/**/*.css' ]
				tasks: [ 'scss_<%= pkg.applicationConfig[ pkg.environment ].type %>' ]
			coffee:
				files: [ 'app/**/*.coffee', 'app/**/*.js', 'app/**/*.html' ]
				tasks: [ 'coffee_<%= pkg.applicationConfig[ pkg.environment ].type %>' ]
			# statics:
			# 	files: [ 'app/**/<%= pkg.imagesDir %>/**/*', '!.build/**/*' ]
			# 	tasks: [ 'copy:prep', 'copy:buildStatics', 'ngtemplates', 'concat', 'htmlbuild:<%= pkg.applicationConfig[ pkg.environment ].type %>', 'copy:deploy' ]
			htmlTarget:
				files: [ 'app/index.html' ]
				tasks: [ 
					'preprocess'
					'htmlbuild:<%= pkg.applicationConfig[ pkg.environment ].type %>'
					if packageJson.applicationConfig[ packageJson.environment ].type is 'production' then 'copy:deployProd' else 'copy:deployDev' 
				]

	grunt.initConfig gruntConfig

	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-sass'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-html-build'
	grunt.loadNpmTasks 'grunt-preprocess'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-angular-templates'
	grunt.loadNpmTasks 'grunt-modernizr'
	grunt.loadNpmTasks 'grunt-bless'
	grunt.loadNpmTasks 'grunt-md5'
	grunt.loadNpmTasks 'grunt-ng-annotate'

	tasksByType = 
		development: [ 
			'clean:all'
			'copy:bower'
			'preprocess'
			'modernizr'
			'copy:prep', 'copy:buildStatics'
			'coffee'
			'ngtemplates'
			'ngAnnotate'
			'sass'
			'concat'
			'uglify'
			'cssmin'
			'bless'
			'preprocess:htmlTarget'
			'md5'
			'htmlbuild:development'
			'copy:deployDev'
		]
		production: [ 
			'clean:all'
			'copy:bower'
			'preprocess'
			'modernizr'
			'copy:prep','copy:buildStatics'
			'coffee'
			'ngtemplates'
			'ngAnnotate'
			'sass'
			'concat'
			'uglify'
			'cssmin'
			'bless'
			'preprocess:htmlTarget'
			'md5'
			'htmlbuild:production'
			'copy:deployProd'
		]

	grunt.registerTask environment, tasksByType[ applicationConfig.type ] for environment, applicationConfig of packageJson.applicationConfig

	grunt.registerTask 'default', tasksByType[ packageJson.applicationConfig[ packageJson.environment ].type ]

	watchTasks =
		scss_development: [ 
			'clean:scss'
			'preprocess:prepScss'
			'preprocess:prepCss'
			'copy:buildStatics'
			'sass'
			'concat:allCss'
			'cssmin'
			'bless'
			'md5:css'
			'htmlbuild:development'
			'copy:deployDev'
		]
		scss_production : [ 'clean:scss', 'preprocess:prepScss', 'preprocess:prepCss', 'copy:buildStatics', 'sass', 'concat:allCss', 'cssmin', 'bless', 'md5:css', 'htmlbuild:production',  'copy:deployProd' ]

		coffee_development: [ 
			'clean:coffee'
			'preprocess:prepCoffee'
			'preprocess:prepJs'
			'preprocess:prepTemplates'
			'modernizr'
			'copy:buildStatics'
			'coffee'
			'ngtemplates'
			'ngAnnotate'
			'concat:allPrettyJs'
			'md5:js'
			'htmlbuild:development'
			'copy:deployDev' 
		]
		coffee_production : [ 'clean:coffee', 'preprocess:prepCoffee', 'preprocess:prepJs', 'preprocess:prepTemplates', 'modernizr', 'copy:buildStatics', 'coffee', 'ngtemplates', 'ngAnnotate', 'concat:allPrettyJs', 'uglify', 'md5:js', 'htmlbuild:production',  'copy:deployProd' ]

	grunt.registerTask watchTasksName, tasks for watchTasksName, tasks of watchTasks

	grunt.log.writeln "Build environment: #{ packageJson.environment }, Build type: #{ packageJson.applicationConfig[ packageJson.environment ].type }"