# Import
moment = require('moment')
truncatise = require('truncatise')

# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
# See http://docpad.org/docs/config

docpadConfig = {

	outPath: 'out'
	srcPath: 'src'

	regenerateDelay: 10

	poweredByDocPad: false

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://johannesharms.com"
			# If not set, will default to the calculated site URL (e.g. http://localhost:9778)

			# Here are some old site urls that you would like to redirect from
			oldUrls: [
				'www.johannesharms.com'
			]

			# The default title of our website
			title: "Johannes Harms"

			# The website description (for SEO)
			description: """
				Johannes works in usability engineering and writes his PhD on web form design.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				johannes harms
				"""

			# The website's styles
			styles: [
				'/vendor/normalize.css'
				'/vendor/h5bp.css'
				'/styles/style.css'
			]

			# The website's scripts
			scripts: [
				# """
				# <!-- jQuery -->
				# <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
				# <script>window.jQuery || document.write('<script src="/vendor/jquery.js"><\\/script>')</script>
				# """

				# '/vendor/log.js'
				# '/vendor/modernizr.js'
				# '/scripts/script.js'
			]


		# -----------------------------
		# Template Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')


		getExcerpt: (content) ->            
			i = content.search('<!-- Read more -->')
			excerpt = if i >= 0 then content[0..i-1] else content
			truncatise excerpt, {
				TruncateLength: 50, 
				TruncateBy : "words", 
				Strict : false, 
				StripHTML : true, 
				Suffix : ''
			}

		hasExcerpt: (content) ->
			content.search('<!-- Read more -->') >= 0

		postDatetime: (date, format="YYYY-MM-DD") -> return moment(date).format(format)
		postDate: (date, format="MMMM DD, YYYY") -> return moment(date).format(format)


	# =================================
	# Collections

	# Here we define our custom collections
	# What we do is we use findAllLive to find a subset of documents from the parent collection
	# creating a live collection out of it
	# A live collection is a collection that constantly stays up to date
	# You can learn more about live collections and querying via
	# http://bevry.me/queryengine/guide

	collections:

		research: ->
			@getCollection("html").findAllLive({
				relativeOutDirPath: 'posts'
				category: 'research'
				layout: $ne: 'redirect'
			},[{date:-1}])

		stuff: ->
			@getCollection("html").findAllLive({
				relativeOutDirPath: 'posts'
				category: $ne: 'research'
				layout: $ne: 'redirect'
			},[{date:-1}])



	# =================================
	# Environments

	# DocPad's default environment is the production environment
	# The development environment, actually extends from the production environment

	# The following overrides our production url in our development environment with false
	# This allows DocPad's to use it's own calculated site URL instead, due to the falsey value
	# This allows <%- @site.url %> in our template data to work correctly, regardless what environment we are in

	environments:
		development:
			templateData:
				site:
					url: false


	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki

	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()




	# =================================
	# Plugins

	plugins:

		menu:
			# configuration example, see https://github.com/sergeche/docpad-plugin-menu/blob/master/src/menu.plugin.coffee
			menuOptions:
				optimize: false
				skipEmpty: true
				skipFiles: ///
					\.js |
					\.css |
					^posts
				///

			moment:
				formats: [
					{ raw: 'date', format: 'MMMM Do YYYY', formatted: 'humanDate' }
					{ raw: 'date', format: 'YYYY-MM-DD', formatted: 'computerDate' }
				]

		rss:
			default:
				collection: 'html',  # optional, this is the default
				url: '/rss.xml' # optional, this is the default
			research:
				collection: 'research',
				url: '/research.xml'
			stuff:
				collection: 'stuff',
				url: '/stuff.xml'

		sitemap:
			cachetime: 600000
			changefreq: 'weekly'
			priority: 0.5
			filePath: 'sitemap.xml'
			#collectionName: 'someCollectionName'

	ignoreCustomPatterns:
		///^_///
}

# Export our DocPad Configuration
module.exports = docpadConfig
